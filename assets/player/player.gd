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
@onready var camera = $GameCamera
@onready var dash_ghost: GPUParticles2D = $DashParticles
@export var wallSlideMod = 12

var momentum_value: float = 1
var momentum_cap: float = 2
@onready var _momentum_cooldown:Timer = $MomentumCooldown

var currentCoins:int = 0

signal onHit
signal onMomentumChanged
signal onCoinCollected

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	
	# Check if the player is touching a wall.
	var is_touching_wall = raycastRight.is_colliding() or raycastLeft.is_colliding()
	sprite.flip_v = false
	# Validate if the player is on wall and not on floor
	if is_touching_wall and not is_on_floor():
		#Set wall texture sprite
		if _momentum_cooldown.is_stopped():
			_momentum_cooldown.start()
		
		
		sprite.frame = 1
		sprite.flip_h = raycastLeft.is_colliding()
		dash_ghost.scale.x = -1 if sprite.flip_h == true else 1
		# Stop the player from sliding up apply normal gravity on impact.
		if velocity.y < 1:
			_calculate_gravity(gravity, delta)
		else: 
			_calculate_gravity(gravity / wallSlideMod, delta)
		# Check if player jumpls from wall
		_check_player_input(WALL_JUMP_HORIZONTAL_VELOCITY * momentum_value)
	
	#if the player is in air apply normal gravity again and check if the player might double jump
	else:
		_calculate_gravity(gravity, delta)
		sprite.frame = 2
		if !_momentum_cooldown.is_stopped():
			_momentum_cooldown.stop()
		
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
			calculate_momentum(0.1)
			velocity = Vector2(-horizontalJumpVelocity, JUMP_VELOCITY)
		elif Input.is_action_just_pressed("Right") and not raycastLeft.is_colliding():
			calculate_momentum(0.1)
			velocity = Vector2(horizontalJumpVelocity, JUMP_VELOCITY)
			
func hit():
	set_physics_process(false)
	respawnTimer.start()
	sprite.queue_free()
	Input.start_joy_vibration(0,0.75,0,0.25)
	deathExplosion.emitting = true;
	camera.shake(1.5,0.5)
	onHit.emit()



func _on_respawn_timer_timeout():
	get_tree().reload_current_scene()

func calculate_momentum(modifier: float, use_particle: bool = true):
	momentum_value += modifier
	if momentum_value < 1:
		momentum_value = 1
	elif momentum_value > momentum_cap:
		momentum_value = momentum_cap
	if momentum_value > 1.5 && use_particle:
		dash_ghost.emitting = true	
	onMomentumChanged.emit(momentum_value)
	

func _on_momentum_cooldown_timeout():
	calculate_momentum(-0.1, false)

func update_coins(value:int):
	currentCoins += value
	onCoinCollected.emit(currentCoins)
	
