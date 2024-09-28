extends CollisionShape2D

func _on_death_area_area_entered(area):
	var parentNode = area.get_parent()
	if parentNode is Player:
		var playerScript = parentNode as Player
		if playerScript:
			playerScript.hit()
