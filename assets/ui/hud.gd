extends Control

class_name Hud

@onready var momentumProgressBar:TextureProgressBar = $momentum_progressbar
@onready var coinValue: Label = $coin_value
@onready var timeLabel:Label = $time_label
var time_elapsed := 0.0

func update_momentum(momentum:float):
	momentumProgressBar.value = momentum

func update_coin(coin: int):
	var formatted_text = str(coin).pad_zeros(3)
	coinValue.text = "x "+formatted_text


func _process(delta):
	time_elapsed += delta
	
	# Convert the elapsed time to minutes and seconds
	var seconds = int(time_elapsed) % 60
	var milliseconds = int((time_elapsed - int(time_elapsed)) * 100)
	
	# Format the time to display it as "MM:SS"
	var formatted_time = "Time: " + str(seconds).pad_zeros(2) + ":" + str(milliseconds).pad_zeros(2)
	
	# Set the text of the Label to display the formatted time
	timeLabel.text = formatted_time
