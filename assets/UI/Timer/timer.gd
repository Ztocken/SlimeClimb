extends Control

@export var player: Player
@export var maxTimeSeconds = 60
var timeRemaining:float = 0
var lastTickTime:float = 0
@onready var countDownLabel = $Timer/CountDown
# Called when the node enters the scene tree for the first time.
func _ready():
	timeRemaining = maxTimeSeconds
	UpdateTimer(maxTimeSeconds)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	lastTickTime += delta
	if lastTickTime >= 1.0:
		timeRemaining -= lastTickTime
		lastTickTime = 0
		UpdateTimer(timeRemaining)
	pass


func UpdateTimer(timeSeconds: float):
	# Calculate minutes and seconds
	var minutes = int(timeSeconds / 60)  # Get whole minutes
	var seconds = int(timeSeconds) % 60    # Get remaining seconds

	# Format the text with leading zeros for seconds
	countDownLabel.text = str(minutes) + ":" + str(seconds).pad_zeros(2)

	if timeSeconds <= 0:
		player.Hit()
