extends Node2D

@onready var projectile = load("res://assets/objects/projectile/projectile.tscn")
@onready var spawnPoint = $spawn
func shoot():
	var instance = projectile.instantiate()
	instance.direction = -1
	instance.spawnPosition = spawnPoint.position + global_position
	instance.spawnRotation = global_rotation
	add_child.call_deferred(instance)



func _on_timer_timeout():
	shoot()
	pass # Replace with function body.
