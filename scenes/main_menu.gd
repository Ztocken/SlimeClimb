extends Control


func _ready():
	GlobalObjects.current_coins = 0
	$VBoxContainer/PlayButton.grab_focus()

func _on_quit_button_button_down():
	get_tree().quit()


func _on_credits_button_button_down():
	pass # Replace with function body.


func _on_options_button_button_down():
	pass # Replace with function body.


func _on_new_game_button_button_down():
	get_tree().change_scene_to_file("res://scenes/gameplay.tscn")
	pass # Replace with function body.


func _on_continue_button_button_down():
	pass # Replace with function body.
