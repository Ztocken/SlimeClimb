extends Node2D



func _on_area_2d_area_entered(area):
	var parentNode = area.get_parent()
	if parentNode is Player:
		var playerScript = parentNode as Player
		print(playerScript)
		if playerScript:
			playerScript.Hit()
