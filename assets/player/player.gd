extends CharacterBody2D
class_name Player

const JUMP_VELOCITY = -300.0
const WALL_JUMP_HORIZONTAL_VELOCITY = 200.0  # Horizontal velocity for wall jumps
const HORIZONTAL_JUMP_VELOCITY = 150.0
# Get the gravity from the project settings to be synced with RigidBody nodes.
@onready var raycastRight = $RayCast2DRight
@onready var raycastLeft = $RayCast2DLeft
@onready var sprite = $Sprite2D
@onready var respawnTimer = $RespawnTimer
@onready var deathExplosion = $DeathExplosion
@export var maxDoubleJumpCount = 1
@export var wallSlideMod = 12

signal onHit

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Check if the player is touching a wall.
	var is_touching_wall = raycastRight.is_colliding() or raycastLeft.is_colliding()
	sprite.flip_v = false
	# Validate if the player is on wall and not on floor
	if is_touching_wall and not is_on_floor():
		#Set wall texture sprite
		sprite.frame = 1
		sprite.flip_h = raycastLeft.is_colliding()
		
		# Stop the player from sliding up apply normal gravity on impact.
		if velocity.y < 1:
			_calculate_gravity(gravity, delta)
		else: 
			_calculate_gravity(gravity / wallSlideMod, delta)
		# Check if player jumpls from wall
		_check_player_input(WALL_JUMP_HORIZONTAL_VELOCITY)
	
	#if the player is in air apply normal gravity again and check if the player might double jump
	else:
		_calculate_gravity(gravity, delta)
		sprite.frame = 2
		
	#check if the player is on floor then apply no gravity
	if is_on_floor():
		velocity.x = 0
		sprite.frame = 0
		# Handle horizontal movement.
		_check_player_input(HORIZONTAL_JUMP_VELOCITY)
	move_and_slide()


func _calculate_gravity(gravity, delta):
	velocity.y += (gravity * delta)
	

func _check_player_input(horizontalJumpVelocity):
		if Input.is_action_just_pressed("Left") and not raycastRight.is_colliding():
			velocity = Vector2(-horizontalJumpVelocity, JUMP_VELOCITY)
		elif Input.is_action_just_pressed("Right") and not raycastLeft.is_colliding():
			velocity = Vector2(horizontalJumpVelocity, JUMP_VELOCITY)
			
func hit():
	set_physics_process(false)
	respawnTimer.start()
	sprite.queue_free()
	deathExplosion.emitting = true;
	onHit.emit()



func _on_respawn_timer_timeout():
	get_tree().reload_current_scene()
