extends Control

class_name Hud

@onready var momentumProgressBar:TextureProgressBar = $MomentumBoxContainer/momentum_progressbar
@onready var coin_label: Label = $VBoxContainer/coin_label
@onready var timeLabel:Label = $VBoxContainer/time_label
@onready var levelLabel:Label = $MomentumBoxContainer/level_label

var time_elapsed := 0.0
var seconds: int = 0
var minutes: int = 0
var tenths: int = 0

func _ready():
	update_coins(GlobalObjects.current_coins)	

func update_level(level: int):
	levelLabel.text = "level " + str(level)
	
func update_momentum(momentum:float):
	momentumProgressBar.value = momentum


func update_coins(coin: int):
	coin_label.text = "Coins: "+ str(coin)
	var tween= get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(coin_label, "scale", coin_label.scale + Vector2( 0.2, 0.2), 0.1).set_ease(Tween.EASE_IN)
	tween.tween_property(coin_label, "scale", coin_label.scale, 0.1).set_ease(Tween.EASE_OUT).set_delay(0.1)

func _process(delta):
	time_elapsed += delta

	# Convert the elapsed time to minutes, seconds, and tenths of a second
	minutes = int(time_elapsed) / 60
	seconds = int(time_elapsed) % 60
	tenths = int((time_elapsed - int(time_elapsed)) * 10)  # Tenths of a second
	# Set the text of the Label to display the formatted time
	timeLabel.text = get_time()

func get_time():
	return "Time: " + str(minutes).pad_zeros(2) + ":" + str(seconds).pad_zeros(2) + "." + str(tenths)
