extends ColorRect

class_name PauseScreen

@onready var resume_button:Button = $pause_container/resume_button

signal restart_level

func pause_game():
	get_tree().paused = true
	self.visible = true
	resume_button.grab_focus()
	
func resume_game():
	get_tree().paused = false
	self.visible = false
	

func _process(delta):
	if Input.is_action_just_pressed("Pause"):
		resume_game()

func _on_quit_button_down():
	resume_game()
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	
func _on_options_button_down():
	pass
	
func _on_restart_button_down():
	resume_game()
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	
func _on_resume_button_down():
	resume_game()
