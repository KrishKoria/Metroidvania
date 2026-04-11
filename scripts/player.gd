extends CharacterBody2D

@export var acceleration = 512
@export var max_speed = 64
@export var max_fall_speed = 80
@export var friction = 256
@export var gravity = 200
@export var jump_force = 128

func is_moving(input: float) -> bool:
	return input != 0

func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y = move_toward(velocity.y, max_fall_speed, gravity * delta)
		
		
func apply_horizontal_movement(delta: float, input: float) -> void:
	if is_moving(input):
		velocity.x = move_toward(velocity.x, input * max_speed, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, friction * delta)

func apply_jump(jump: bool) -> void:
	if jump and is_on_floor():
		velocity.y = -jump_force

func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	var input = Input.get_axis("ui_left", "ui_right")
	apply_horizontal_movement(delta, input)
	var jump = Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_accept")
	apply_jump(jump)
	move_and_slide()
