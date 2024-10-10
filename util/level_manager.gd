extends Node2D

@onready var hud:Hud = $CanvasLayer/HUD
@onready var level: Node2D = $Level

@onready var gameover_screen: GameOverScreen = $CanvasLayer/game_overscreen
@onready var victory_screen: VictoryScreen = $CanvasLayer/victory_screen
@onready var pause_screen: PauseScreen = $CanvasLayer/pause_screen

@export var level_path: String = "res://assets/levels/"
signal on_transition_finished

var _levelContainer: Node2D
var _player: Player
var _levelExit: LevelExit

var _current_level: int 

var collected_coins: int = 0
var deaths:int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	gameover_screen.visible = false
	victory_screen.visible = false
	pause_screen.visible = false
	_levelContainer = get_tree().get_first_node_in_group("level_container")
	gameover_screen.retry_level.connect(restart_level)
	change_level(1)

func _process(delta):
	if Input.is_action_just_pressed("Pause"):
		pause_screen.pause_game()

func add_coins(value:int):
	collected_coins += value
	hud.update_coins(GameObjectManager.player_data.coins + collected_coins)
	
func game_over():
	deaths += 1
	hud.reset_timer()
	gameover_screen.activate_game_over_screen(_current_level, hud.timespan)

func restart_level():
	get_tree().paused = false
	change_level(_current_level)

func victory(next_level:int):
	hud.pause_timer = true
	GameObjectManager.player_data.coins += collected_coins
	victory_screen.activate_victory_screen(_current_level,hud.timespan,collected_coins,deaths)
	await victory_screen.victory_screen_compleeted
	hud.pause_timer = false
	hud.reset_timer()
	change_level(next_level)
	
func change_level(level: int):
	deaths = 0
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
	_levelExit.onPlayerExit.connect(victory)
	_player.onCoinCollected.connect(add_coins)
	_player.respawn.connect(game_over)
	hud.update_coins(GameObjectManager.player_data.coins)

func _on_pause_button_down():
	pause_screen.pause_game()
