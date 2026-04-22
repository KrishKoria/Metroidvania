extends CharacterBody2D

@export var acceleration = 512
@export var max_speed = 64
@export var max_fall_speed = 80
@export var friction = 256
@export var gravity = 200
@export var jump_force = 128

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var edge_left_timer: Timer = $EdgeLeftTimer
@onready var player_blaster: Node2D = $PlayerBlaster

const DustEffectScene = preload("res://scenes/dust_effect.tscn")

func is_moving(input: float) -> bool:
	return input != 0

func update_animation(input: float) -> void:
	var mouse_dir = sign(get_local_mouse_position().x)
	if mouse_dir != 0:
		sprite_2d.scale.x = mouse_dir

	animation_player.speed_scale = 1.0
	if not is_on_floor():
		animation_player.play("jump")
	elif is_moving(input):
		animation_player.play("run")
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
	if is_on_floor() or edge_left_timer.time_left > 0.0:
		if jump_pressed:
			velocity.y = -jump_force
			create_dust_effect()
	if not is_on_floor():
		if jump_released and velocity.y < -jump_force / 2:
			velocity.y = -jump_force / 2

func create_dust_effect() -> void:
	var dust_effect = DustEffectScene.instantiate()
	get_tree().current_scene.add_child(dust_effect)
	dust_effect.global_position = global_position

func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	var input = Input.get_axis("move_left", "move_right")
	apply_horizontal_movement(delta, input)
	var jump_pressed = Input.is_action_just_pressed("jump")
	var jump_released = Input.is_action_just_released("jump")
	apply_jump(jump_pressed, jump_released)
	if Input.is_action_just_pressed("fire"):
		player_blaster.fire_bullet()
	update_animation(input)
	var was_on_floor = is_on_floor()
	move_and_slide()
	var just_left_edge = was_on_floor and not is_on_floor() and velocity.y >= 0
	if just_left_edge:
		edge_left_timer.start()
	if not was_on_floor and is_on_floor():
		create_dust_effect()
