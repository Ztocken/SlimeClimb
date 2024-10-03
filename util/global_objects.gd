extends Node

class_name GlobalObjects

static var tile_objects = {
	Vector2(0,0): {"object": preload("res://assets/objects/spikes/spikes.tscn"), "data":{}},
	Vector2(0,1): {"object": preload("res://assets/objects/canon/canon.tscn"), "data":{}},
	Vector2(0,2): {"object": preload("res://assets/objects/jump_pad/jump_pad.tscn"), "data":{}},
	Vector2(1,2): {"object": preload("res://assets/objects/jump_pad/jump_pad.tscn"), "data":{"direction":1}},
	Vector2(2,1): {"object": preload("res://assets/player/player.tscn"), "data":{}},
	Vector2(1,0): {"object": preload("res://assets/objects/spikes/spikes.tscn"), "data":{"flipH":true,"moveDeathArea":8}},
	Vector2(3,0): {"object": preload("res://assets/objects/coin/coin.tscn"), "data":{}},
}

static var starting_level: int = 1
static var current_coins: int = 0 

