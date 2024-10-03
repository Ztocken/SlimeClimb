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
@onready var _momentum_cooldown:Timer = $MomentumCooldown
@onready var player_animation: AnimationPlayer = $Sprite2D/player_animation
@onready var slideParticle: CPUParticles2D = $slideParticle
@export var wallSlideMod = 12

var momentum_value: float = 1
var momentum_cap: float = 2
signal onHit
signal respawn
signal onMomentumChanged
signal onCoinCollected

var first_floor_impact: bool = true

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
		
		slideParticle.emitting = true
		
		if raycastLeft.is_colliding():
			slideParticle.position = Vector2(16,11)
		elif raycastRight.is_colliding():
			slideParticle.position = Vector2(0,11)
		
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
		slideParticle.emitting = false
		_calculate_gravity(gravity, delta)
		sprite.frame = 2
		if !_momentum_cooldown.is_stopped():
			_momentum_cooldown.stop()
		
	#check if the player is on floor then apply no gravity
	if is_on_floor():
		if first_floor_impact:
			first_floor_impact = false
			var tween = get_tree().create_tween()
			tween.tween_property(sprite, "scale:x", 1.1, 0.05).set_ease(Tween.EASE_IN)
			tween.tween_property(sprite, "scale:x", 1, 0.05).set_ease(Tween.EASE_OUT).set_delay(0.05)
			if tween.finished:
				player_animation.play("idle")
		if _momentum_cooldown.is_stopped():
			_momentum_cooldown.start()
		velocity.x = 0
		sprite.frame = 0
		# Handle horizontal movement.
		_check_player_input(HORIZONTAL_JUMP_VELOCITY)
	else:
		player_animation.stop()
	move_and_slide()


func _calculate_gravity(gravity, delta):
	velocity.y += (gravity * delta)
	

func _check_player_input(horizontalJumpVelocity):
		if Input.is_action_just_pressed("Left") and not raycastRight.is_colliding():
			var tween = get_tree().create_tween()
			tween.tween_property(sprite, "scale:x", 0.8, 0.05).set_ease(Tween.EASE_IN)
			jump(-horizontalJumpVelocity)

		elif Input.is_action_just_pressed("Right") and not raycastLeft.is_colliding():
			var tween = get_tree().create_tween()
			tween.tween_property(sprite, "scale:x", 0.8, 0.05).set_ease(Tween.EASE_IN)
			jump(horizontalJumpVelocity)

func jump(horizontalJumpVelocity: float):
	first_floor_impact = true
	var jump_tween = get_tree().create_tween()
	jump_tween.tween_property(sprite, "scale", Vector2(0.9,1.2), 0.05).set_ease(Tween.EASE_IN)
	jump_tween.tween_property(sprite, "scale", Vector2.ONE, 0.05).set_ease(Tween.EASE_OUT).set_delay(0.05)
	var tween= get_tree().create_tween()
	tween.set_parallel(true)
	calculate_momentum(0.1)
	sprite.flip_h = horizontalJumpVelocity < 0
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
	respawn.emit()

func calculate_momentum(modifier: float, use_particle: bool = true):
	momentum_value += modifier
	if momentum_value < 1:
		momentum_value = 1
	elif momentum_value > momentum_cap:
		momentum_value = momentum_cap
	if momentum_value > 1.7 && use_particle:
		dash_ghost.emitting = true	
	onMomentumChanged.emit(momentum_value)
	

func _on_momentum_cooldown_timeout():
	calculate_momentum(-0.1, false)

func update_coins(value:int, position: Vector2):
	onCoinCollected.emit(value)
	DisplayInfo.display_info("+"+str(value),position)
	
