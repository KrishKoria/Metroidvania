extends Node2D

const BulletScene = preload("res://scenes/bullet.tscn")

@onready var blaster_sprite: Sprite2D = $BlasterSprite
@onready var muzzle: Marker2D = $BlasterSprite/Muzzle

func _process(delta: float) -> void:
	blaster_sprite.rotation = get_local_mouse_position().angle()
	
func fire_bullet() -> void:
	var bullet = BulletScene.instantiate()
	var world = get_tree().current_scene
	world.add_child(bullet)
	bullet.rotation = blaster_sprite.rotation
	bullet.global_position = muzzle.global_position
