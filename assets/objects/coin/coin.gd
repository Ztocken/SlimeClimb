extends Node2D

class_name Coin


func _on_area_2d_area_entered(area):
	var parentNode = area.get_parent()
	if parentNode is Player:
		self.queue_free()
