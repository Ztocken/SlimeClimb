extends Node2D



func _on_area_2d_area_entered(area):
	get_tree().reload_current_scene()
