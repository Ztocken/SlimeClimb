extends Node2D

class_name LevelExit
@export var next_level: int = 0 
signal onPlayerExit

func _on_area_2d_area_entered(area):
	var parentNode = area.get_parent()
	if parentNode is Player:
		var player = parentNode as Player
		onPlayerExit.emit(next_level)
