extends Control

@onready var scoreValue = $ScoreContainer/ScoreValue
var currentScore:int = 0
func addScore(value:int):
	currentScore += value
	scoreValue.text = str("SCORE: ",currentScore)
