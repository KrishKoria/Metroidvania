extends CharacterBody2D

@export var acceleration = 512
@export var max_speed = 64
@export var max_fall_speed = 80
@export var friction = 256
@export var gravity = 200
@export var jump_force = 128

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D


func is_moving(input: float) -> bool:
	return input != 0


func update_animation(input: float) -> void:
	if not is_on_floor():
		animation_player.play("jump")
		return

	if is_moving(input):
		animation_player.play("run")
		sprite_2d.scale.x = sign(input)
	else:
		animation_player.play("idle")


func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y = move_toward(velocity.y, max_fall_speed, gravity * delta)


func apply_horizontal_movement(delta: float, input: float) -> void:
	if is_moving(input):
		velocity.x = move_toward(velocity.x, input * max_speed, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, friction * delta)


func apply_jump(jump_pressed: bool, jump_released: bool) -> void:
	if is_on_floor():
		if jump_pressed:
			velocity.y = -jump_force
	else:
		if jump_released and velocity.y < -jump_force / 2:
			velocity.y = -jump_force / 2


func _physics_process(delta: float) -> void:
	apply_gravity(delta)

	var input = Input.get_axis("ui_left", "ui_right")
	apply_horizontal_movement(delta, input)

	var jump_pressed = Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_accept")
	var jump_released = Input.is_action_just_released("ui_up") or Input.is_action_just_released("ui_accept")
	apply_jump(jump_pressed, jump_released)

	update_animation(input)
	move_and_slide()
