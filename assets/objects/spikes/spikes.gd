extends Node2D

@export var flipH: bool = false
@export var moveDeathArea: int = 0

@onready var _sprite = $Sprite2D
@onready var _deathArea = $DeathArea
# Called when the node enters the scene tree for the first time.
func _ready():
	_sprite.flip_h = flipH
	_deathArea.position.x += moveDeathArea
