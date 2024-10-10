extends Control

class_name Hud

@onready var coin_label: Label = $MarginContainer/VBoxContainer/coin_label
@onready var timeLabel:Label = $MarginContainer/VBoxContainer/time_label
@onready var levelLabel:Label = $MarginContainer/VBoxContainer/level_label

var pause_timer: bool = false
var timespan: float = 0

func _ready():
	update_coins(GameObjectManager.player_data.coins)

func update_level(level: int):
	levelLabel.text = "level " + str(level)

func update_coins(coin: int):
	coin_label.text = "Coins: "+ str(coin)
	var tween= get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(coin_label, "scale", coin_label.scale + Vector2( 0.2, 0.2), 0.1).set_ease(Tween.EASE_IN)
	tween.tween_property(coin_label, "scale", coin_label.scale, 0.1).set_ease(Tween.EASE_OUT).set_delay(0.1)

func _set_font_color(new_color: Color):
	coin_label.add_color_override("font_color", new_color)
	
func reset_timer():
	timespan = 0
	
func _process(delta):
	if pause_timer:
		return
	timespan += delta
	# Set the text of the Label to display the formatted time
	timeLabel.text = Toolkit.get_time(timespan)


