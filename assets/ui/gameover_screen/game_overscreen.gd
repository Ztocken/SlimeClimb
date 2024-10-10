extends ColorRect

class_name GameOverScreen

#display labels
@onready var level_label:Label = $retry_container/HBoxContainer/level_label
@onready var time_label:Label = $retry_container/HBoxContainer/time_label
@onready var coin_label:Label = $retry_container/HBoxContainer/coin_label
@onready var title:Label = $retry_container/title

@onready var retry_button_coin: Button = $retry_container/retry_button_coin
@onready var retry_button_ad: Button = $retry_container/retry_button_ad

var gameover_titles = [
	"Well, that happened.",
	"Whoops!",
	"Nice try... not!",
	"You did what?",
	"Was that smart?",
	"That was rough.",
	"Oopsie daisy!",
	"Maybe next time?",
	"Good effort?",
	"Better luck next time!",
	"Oh no... not my perfect score!"
]

signal retry_level

func activate_game_over_screen(level:int, timespan:int):
	self.visible = true
	get_tree().paused = true
	# Seed the random number generator
	randomize()
	
	#update display with data
	level_label.text = "Level " + str(level)
	time_label.text = Toolkit.get_time(timespan)
	coin_label.text = "Coin " + str(GameObjectManager.player_data.coins)
	title.text = gameover_titles[randi() % gameover_titles.size()]
	
	
	retry_button_coin.disabled = GameObjectManager.player_data.coins < 20
	
	if retry_button_coin.disabled:
		retry_button_coin.grab_focus()
	else:
		retry_button_ad.grab_focus()

func retry_level_pay_coin():
	self.visible = false
	GameObjectManager.player_data.coins -= 20
	retry_level.emit()
	
func retry_level_watch_ad():
	self.visible = false
	retry_level.emit()

func restart():
	self.visible = false
	get_tree().paused = false
	get_tree().reload_current_scene()

func quit_main_menu():
	self.visible = false
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
