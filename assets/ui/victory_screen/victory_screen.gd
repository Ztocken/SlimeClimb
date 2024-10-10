extends Control

class_name VictoryScreen

@onready var _victory_animation: AnimationPlayer = $victory_animation

@onready var _level_label: Label = $victory_container/level_stats/level_label
@onready var _time_label: Label = $victory_container/level_stats/time_label
@onready var _coins_label: Label = $victory_container/player_stats/coin_label
@onready var _deaths_label: Label = $victory_container/player_stats/death_label

var calculated_score: int = 1
var animation_skipped: bool = false
signal victory_screen_compleeted

func _input(event):
	if event.is_action_pressed("ui_accept"):
		_victory_animation.seek(_victory_animation.current_animation_length - 0.5)


func  activate_victory_screen(level:int, timespan:int, coins:int, deaths:int):
	self.visible = true
	get_tree().paused = true
	
	if coins > 0:
		_coins_label.add_theme_color_override("font_color", Color("b3ffa3"))
	else:
		_coins_label.remove_theme_color_override("font_color")
		
	if deaths > 0:
		_deaths_label.add_theme_color_override("font_color", Color ("ffa3a3"))
	else:
		_deaths_label.remove_theme_color_override("font_color")
	
	_level_label.text = "Level " + str(level)
	_time_label.text = Toolkit.get_time(timespan)
	_coins_label.text = "Coins: +" + str(coins)
	_deaths_label.text = "Deaths: " + str(deaths)
	
	_victory_animation.play("display_victory_screen")
	await  _victory_animation.animation_finished
	self.visible = false
	get_tree().paused = false
	victory_screen_compleeted.emit(calculated_score)
