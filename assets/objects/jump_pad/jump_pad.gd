extends Node2D

@export var direction: int = -1
@onready var sprite:Sprite2D = $Sprite2D
func _ready():
	sprite.flip_h = direction < 0
	
func _on_area_2d_area_entered(area):
	var parentNode = area.get_parent()
	if parentNode is Player:
		var playerScript = parentNode as Player
		if playerScript:
			playerScript.jump(playerScript.WALL_JUMP_HORIZONTAL_VELOCITY * direction)
