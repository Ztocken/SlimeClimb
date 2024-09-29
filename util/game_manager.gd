extends Node2D

@onready var hud:Hud = $CanvasLayer/HUD
@export var level_path: String = "res://assets/levels/"

var _levelContainer: Node2D
var _player: Player

var _current_level: int = 1
var _starting_level: int = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	_levelContainer = get_tree().get_first_node_in_group("level_container")
	change_level(GlobalObjects.starting_level)

func change_level(level_name: String):
	var full_path = level_path + level_name + ".tscn"
	print("loading " + full_path)
	var scene = load(full_path) as PackedScene
	
	if !scene:
		return
		
	for child in _levelContainer.get_children():
		child.queue_free()
		await  child.tree_exited
		
	var sceneInstance = scene.instantiate()
	_levelContainer.add_child(sceneInstance)
	_player = get_tree().get_first_node_in_group("player")
	_player.onMomentumChanged.connect(hud.update_momentum)
	_player.onCoinCollected.connect(hud.update_coin)
