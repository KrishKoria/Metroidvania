extends Node2D

const BulletScene = preload("res://scenes/bullet.tscn")

@export var fire_interval := 0.25

@onready var blaster_sprite: Sprite2D = $BlasterSprite
@onready var muzzle: Marker2D = $BlasterSprite/Muzzle

var fire_cooldown := 0.0

func _process(delta: float) -> void:
	blaster_sprite.rotation = get_local_mouse_position().angle()
	fire_cooldown = max(fire_cooldown - delta, 0.0)

func try_fire() -> void:
	if fire_cooldown > 0.0:
		return

	fire_bullet()
	fire_cooldown = fire_interval

func fire_bullet() -> void:
	var bullet = Utils.instantiate_on_world(BulletScene, muzzle.global_position)
	bullet.rotation = blaster_sprite.global_rotation
	bullet.update_velocity()
