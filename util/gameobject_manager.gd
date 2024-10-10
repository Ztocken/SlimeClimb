extends Node

class_name GameObjectManager

var _init_listener_applovin = AppLovinMAX.InitializationListener.new()

const _save_data_path:String = "user://data/"
const player_save_file: String = "player.data"
const settings_save_file: String = "settings.data"

const _security_key = "cc3d75695df12c96cd62b712ba408c7915db07651693d57144417d7a651d4dde"


const tile_objects = {
	Vector2(0,0): {"object": preload("res://assets/objects/spikes/spikes.tscn"), "data":{}},
	Vector2(0,1): {"object": preload("res://assets/objects/canon/canon.tscn"), "data":{}},
	Vector2(0,2): {"object": preload("res://assets/objects/jump_pad/jump_pad.tscn"), "data":{}},
	Vector2(1,2): {"object": preload("res://assets/objects/jump_pad/jump_pad.tscn"), "data":{"direction":1}},
	Vector2(2,1): {"object": preload("res://assets/player/player.tscn"), "data":{}},
	Vector2(1,0): {"object": preload("res://assets/objects/spikes/spikes.tscn"), "data":{"flipH":true,"moveDeathArea":8}},
	Vector2(3,0): {"object": preload("res://assets/objects/coin/coin.tscn"), "data":{}},
}

static var player_data: PlayerData = PlayerData.new()

func _ready():
	DirAccess.make_dir_absolute(_save_data_path)
	load_player_data(player_save_file, true)

static func save_data(file_name:String, encrypted:bool):
	var file = FileAccess.open_encrypted_with_pass(_save_data_path + file_name, FileAccess.WRITE, _security_key)
	if file == null:
		print(FileAccess.get_open_error())
		return
	file.store_var(player_data.coins)
	file.close()
	print("saved file: " + file.get_path_absolute())
	
func load_player_data(file_name:String, encrypted:bool):
	if FileAccess.file_exists(_save_data_path + file_name):
		var file = FileAccess.open_encrypted_with_pass(_save_data_path + file_name, FileAccess.READ, _security_key)
		player_data.coins = file.get_var(player_data.coins)
		file.close()
