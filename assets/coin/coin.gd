extends Node2D

@export var scoreAmmount: int = 1
func _on_area_2d_area_entered(area):
	var parentNode = area.get_parent()
	if parentNode is Player:
		var playerScript = parentNode as Player
		if playerScript:
			playerScript.score.addScore(scoreAmmount)
			queue_free()
