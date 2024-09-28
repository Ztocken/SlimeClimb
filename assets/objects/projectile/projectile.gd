extends CharacterBody2D
@export var speed: float = 100
var direction : float
var spawnPosition: Vector2
var spawnRotation: float = 0
func _ready():
	global_position = spawnPosition
	
	
func _physics_process(delta):
	velocity = Vector2(speed + direction,0)
	var collision = move_and_collide(velocity * delta);
	if collision:
		self.queue_free()
