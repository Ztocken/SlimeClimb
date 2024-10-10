extends CharacterBody2D
class_name Player

const JUMP_VELOCITY = -300.0
const WALL_JUMP_HORIZONTAL_VELOCITY = 220.0  # Horizontal velocity for wall jumps
const HORIZONTAL_JUMP_VELOCITY = 150.0
# Get the gravity from the project settings to be synced with RigidBody nodes.
@onready var raycastRight = $RayCast2DRight
@onready var raycastLeft = $RayCast2DLeft
@onready var sprite = $Sprite2D
@onready var respawnTimer = $RespawnTimer
@onready var deathExplosion = $DeathExplosion
@onready var camera:Camera2D = $GameCamera
@onready var player_animation: AnimationPlayer = $Sprite2D/player_animation
@onready var slideParticle: CPUParticles2D = $slideParticle
@onready var dust_animation:AnimationPlayer = $Dust/DustAnimation
@onready var dust_sprite:Sprite2D = $Dust
@onready var dust_trail:GPUParticles2D = $DustTrail
@onready var jump_timer: Timer = $jump_cooldown
@export var wallSlideMod = 12

signal onHit
signal respawn
signal onCoinCollected

var first_floor_impact: bool = true

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var joystick_deadzone:float = 0.2
var max_vertical_offset:float = 100 # Maximum vertical offset for the camera
var camera_smoothness:float = 5.0 # Higher values make the camera move faster
var target_vertical_offset:float = 0.0 # The target offset we're interpolating toward
var swipe_threshold = 5
var touch_start_position = Vector2()
var touch_end_position = Vector2()
var swipe_distance_vertical = 0
var vertical_input: float = 0
var fist_wall_impact : bool = false
var can_jump: bool = true

func _input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			# Store the initial touch position
			touch_start_position = event.position
			
	elif event is InputEventScreenDrag:
			touch_end_position = event.position
			swipe_distance_vertical = touch_end_position.x - touch_start_position.x

func _physics_process(delta):
	vertical_input = float(Input.get_joy_axis(0, JOY_AXIS_LEFT_Y))
	if abs(vertical_input) < joystick_deadzone:
		vertical_input = 0
	
	if Input.is_action_pressed("look_up"):
		vertical_input = -1.0 # W key (up)
	
	target_vertical_offset = float(vertical_input * max_vertical_offset)
	camera.offset.y = lerp(camera.offset.y, target_vertical_offset, camera_smoothness * delta)

	# Check if the player is touching a wall.
	var is_touching_wall = raycastRight.is_colliding() or raycastLeft.is_colliding()
	sprite.flip_v = false
	# Validate if the player is on wall and not on floor
	if is_touching_wall and not is_on_floor():
		#Set wall texture sprite
		if !dust_sprite.visible:
			dust_sprite.visible = true
			dust_animation.play("impact")
		
		sprite.frame = 1
		sprite.flip_h = raycastLeft.is_colliding()
		dust_sprite.flip_h = !sprite.flip_h
		
		slideParticle.emitting = true
		
		if raycastLeft.is_colliding():
			slideParticle.position = Vector2(16,11)
		elif raycastRight.is_colliding():
			slideParticle.position = Vector2(0,11)
		# Stop the player from sliding up apply normal gravity on impact.
		if velocity.y < 1:
			_calculate_gravity(gravity, delta)
		else: 
			_calculate_gravity(gravity / wallSlideMod, delta)
		# Check if player jumpls from wall
		_check_player_input(WALL_JUMP_HORIZONTAL_VELOCITY)
	
	#if the player is in air apply normal gravity again and check if the player might double jump
	else:
		dust_sprite.visible = false
		slideParticle.emitting = false
		_calculate_gravity(gravity, delta)
		sprite.frame = 2
		
	#check if the player is on floor then apply no gravity
	if is_on_floor():
		if first_floor_impact:
			first_floor_impact = false
			var tween = get_tree().create_tween()
			tween.tween_property(sprite, "scale:x", 1.1, 0.05).set_ease(Tween.EASE_IN)
			tween.tween_property(sprite, "scale:x", 1, 0.05).set_ease(Tween.EASE_OUT).set_delay(0.05)
			if tween.finished:
				player_animation.play("idle")
		velocity.x = 0
		if camera.offset.y < -25:
			sprite.frame = 5
		elif camera.offset.y > 25:
			sprite.frame = 6
		else:
			sprite.frame = 0
		# Handle horizontal movement.
		_check_player_input(HORIZONTAL_JUMP_VELOCITY)
	else:
		player_animation.stop()
	move_and_slide()


func _calculate_gravity(gravity, delta):
	velocity.y += (gravity * delta)
	

func _check_player_input(horizontalJumpVelocity):
		if (Input.is_action_just_pressed("Left") or swipe_distance_vertical < -swipe_threshold) and not raycastRight.is_colliding() : 
			var tween = get_tree().create_tween()
			tween.tween_property(sprite, "scale:x", 0.8, 0.05).set_ease(Tween.EASE_IN)
			jump(-horizontalJumpVelocity)

		elif (Input.is_action_just_pressed("Right") or swipe_distance_vertical > swipe_threshold) and not raycastLeft.is_colliding():
			var tween = get_tree().create_tween()
			tween.tween_property(sprite, "scale:x", 0.8, 0.05).set_ease(Tween.EASE_IN)
			jump(horizontalJumpVelocity)

func jump(horizontalJumpVelocity: float):
	first_floor_impact = true
	var jump_tween = get_tree().create_tween()
	jump_tween.tween_property(sprite, "scale", Vector2(0.9,1.2), 0.05).set_ease(Tween.EASE_IN)
	jump_tween.tween_property(sprite, "scale", Vector2.ONE, 0.05).set_ease(Tween.EASE_OUT).set_delay(0.05)
	sprite.flip_h = horizontalJumpVelocity < 0
	velocity = Vector2(horizontalJumpVelocity, JUMP_VELOCITY)



func hit():
	set_physics_process(false)
	respawnTimer.start()
	sprite.queue_free()
	Input.start_joy_vibration(0,0.75,0,0.25)
	Input.vibrate_handheld(100)
	deathExplosion.emitting = true;
	camera.shake(2.5,0.5)
	onHit.emit()



func _on_respawn_timer_timeout():
	respawn.emit()

func update_coins(value:int, position: Vector2):
	onCoinCollected.emit(value)
	DisplayInfo.display_info("+"+str(value),position)
	
