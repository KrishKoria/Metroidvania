extends Node2D

@export var speed = 250

var velocity = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func update_velocity() -> void:
	velocity.x = speed
	velocity = velocity.rotated(rotation)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += velocity * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
