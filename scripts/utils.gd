extends Node

func instantiate_on_world(scene: PackedScene, position: Vector2):
	var main = get_tree().current_scene
	var instance = scene.instantiate()
	main.add_child(instance)
	instance.global_position = position
	return instance
