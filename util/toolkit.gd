extends Node

@onready var os: String = OS.get_name()

#convert time elapsed to minutes, seconds and tenths
func get_time(time_elapsed: int) -> String:

	var minutes = int(time_elapsed) / 60
	var seconds = int(time_elapsed) % 60
	var tenths = int((time_elapsed - int(time_elapsed)) * 10)

	return "Time: " + str(minutes).pad_zeros(2) + ":" + str(seconds).pad_zeros(2) + "." + str(tenths)
