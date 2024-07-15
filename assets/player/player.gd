extends CharacterBody2D
class_name Player

const JUMP_VELOCITY = -300.0
const WALL_JUMP_HORIZONTAL_VELOCITY = 200.0  # Horizontal velocity for wall jumps
const HORIZONTAL_JUMP_VELOCITY = 150.0
# Get the gravity from the project settings to be synced with RigidBody nodes.
@onready var raycastRight = $RayCast2DRight
@onready var raycastLeft = $RayCast2DLeft
@onready var sprite = $Sprite2D

@export var normal_texture: Texture2D
@export var falling_texture: Texture2D
@export var stuckwall_texture: Texture2D

@export var maxDoubleJumpCount = 1
@export var doublejumpCount = 0;
@export var wallSlideMod = 12

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	# Check if the player is touching a wall.
	var is_touching_wall = raycastRight.is_colliding() or raycastLeft.is_colliding()
	sprite.flip_v = false
	# Validate if the player is on wall and not on floor
	if is_touching_wall and not is_on_floor():
		# Reset  double jump count
		doublejumpCount = 0
		#Set wall texture sprite
		sprite.texture = stuckwall_texture
		sprite.flip_h = raycastLeft.is_colliding()
		
		# Stop the player from sliding up apply normal gravity on impact.
		if velocity.y < 1:
			CalculateGravity(gravity, delta)
		else: 
			CalculateGravity(gravity / wallSlideMod, delta)
		# Check if player jumpls from wall
		CheckPlayerInputWallJump(false, WALL_JUMP_HORIZONTAL_VELOCITY)
	
	#if the player is in air apply normal gravity again and check if the player might double jump
	else:
		sprite.texture = falling_texture
		CalculateGravity(gravity, delta)
		
		if doublejumpCount < maxDoubleJumpCount:
			CheckPlayerInputWallJump(true , WALL_JUMP_HORIZONTAL_VELOCITY)
	#check if the player is on floor then apply no gravity
	if is_on_floor():
		velocity.x = 0
		sprite.texture = normal_texture
		# Handle horizontal movement.
		CheckPlayerInputWallJump(false, HORIZONTAL_JUMP_VELOCITY)
	move_and_slide()

func CalculateGravity(gravity, delta):
	velocity.y += (gravity * delta)
	

func CheckPlayerInputWallJump(useDoubleJump, horizontalJumpVelocity):
		if Input.is_action_just_pressed("Left") and not raycastRight.is_colliding():
			velocity = Vector2(-horizontalJumpVelocity, JUMP_VELOCITY)
			if useDoubleJump:
				doublejumpCount += 1
		elif Input.is_action_just_pressed("Right") and not raycastLeft.is_colliding():
			velocity = Vector2(horizontalJumpVelocity, JUMP_VELOCITY)
			if useDoubleJump:
				doublejumpCount += 1
func Hit():
	get_tree().reload_current_scene()
