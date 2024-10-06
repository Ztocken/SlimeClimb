extends Node2D

@onready var hud:Hud = $CanvasLayer/HUD
@onready var level: Node2D = $Level
@onready var retry_box:Control = $CanvasLayer/retry_box
@onready var pause_box: Control = $CanvasLayer/pause_box
@onready var retry_button: Button = $CanvasLayer/retry_box/retry_container/retry_button
@onready var reset_button: Button = $CanvasLayer/retry_box/retry_container/reset_button
@onready var quit_button: Button = $CanvasLayer/retry_box/retry_container/quit_button
@onready var restart_button: Button = $CanvasLayer/pause_box/pause_container/restart_button

@onready var resume_button: Button = $CanvasLayer/pause_box/pause_container/resume_button
@onready var time_label: Label = $CanvasLayer/retry_box/retry_container/HBoxContainer/time_label
@onready var coin_label: Label = $CanvasLayer/retry_box/retry_container/HBoxContainer/coin_label
@onready var level_label: Label = $CanvasLayer/retry_box/retry_container/HBoxContainer/level_label

@export var level_path: String = "res://assets/levels/"
signal on_transition_finished

var _levelContainer: Node2D
var _player: Player
var _levelExit: LevelExit
var _current_level: int 
var _starting_level: int = 1
var can_pause:bool = true
var collected_coins: int = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	retry_box.visible = false
	pause_box.visible = false
	_levelContainer = get_tree().get_first_node_in_group("level_container")
	change_level(GlobalObjects.starting_level)

func _process(delta):
	if Input.is_action_just_pressed("Pause"):
		pause()

func add_coins(value:int):
	collected_coins += value
	GlobalObjects.current_coins += value
	hud.update_coins(GlobalObjects.current_coins)
func resume():
	pause_box.visible = false
	get_tree().paused = false

func pause():
	restart_button.disabled = !_player.is_on_floor()
	pause_box.visible = true
	get_tree().paused = true
	resume_button.grab_focus()
		
func game_over():
	coin_label.text = "Coin: " + str(GlobalObjects.current_coins)
	time_label.text = hud.get_time()
	level_label.text = "Level " + str(_current_level)
	can_pause = false
	get_tree().paused = true
	retry_box.visible = true
	retry_button.disabled = GlobalObjects.current_coins < 20
	if retry_button.disabled:
		reset_button.grab_focus()
	else:
		retry_button.grab_focus()
		
		
func change_level(level: int):
	collected_coins = 0
	_current_level = level
	var full_path = level_path + "level" + str(level) + ".tscn"
	var scene = load(full_path) as PackedScene
	if !scene:
		return
	hud.update_level(level)
	for child in _levelContainer.get_children():
		child.queue_free()
		await  child.tree_exited
	
	var sceneInstance = scene.instantiate()
	_levelContainer.add_child(sceneInstance)
	_player = get_tree().get_first_node_in_group("player")
	_levelExit = get_tree().get_first_node_in_group("level_exit")
	_levelExit.onPlayerExit.connect(change_level)
	_player.onCoinCollected.connect(add_coins)
	_player.respawn.connect(game_over)


func _on_retry_button_button_down():
	get_tree().paused = false
	retry_box.visible = false
	GlobalObjects.current_coins -= 20
	hud.update_coins(GlobalObjects.current_coins)
	change_level(_current_level)	


func _on_restart_button_button_down():
	retry_box.visible = false
	pause_box.visible = false
	get_tree().paused = false
	GlobalObjects.current_coins -= collected_coins
	hud.update_coins(GlobalObjects.current_coins)
	change_level(_current_level)


func _on_quit_button_button_down():
	retry_box.set_process(false)
	retry_box.visible = false
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_resume_button_button_down():
	resume()
	

func _on_reset_button_button_down():
	retry_box.visible = false
	pause_box.visible = false
	get_tree().paused = false
	get_tree().reload_current_scene()
