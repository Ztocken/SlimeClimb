extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -250.0
const WALL_JUMP_HORIZONTAL_VELOCITY = 200.0  # Horizontal velocity for wall jumps
const WALL_SLIDE_GRAVITY = 50.0  # Reduced gravity for wall sliding

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var raycastRight = $RayCast2DRight
@onready var raycastLeft = $RayCast2DLeft
@onready var sprite = $Sprite2D
var is_wall_jumping = false

@export var normal_texture: Texture2D
@export var falling_texture: Texture2D
@export var stuckwall_texture: Texture2D
var canDoubleJump = false
func _physics_process(delta):
	# Check if the player is touching a wall.
	var is_touching_wall = raycastRight.is_colliding() or raycastLeft.is_colliding()
	
	sprite.flip_v = false
	# Add the gravity.
	if is_touching_wall and not is_on_floor():
		canDoubleJump = true
		sprite.texture = stuckwall_texture
		sprite.flip_h = raycastLeft.is_colliding()
		# Reduce gravity when touching a wall to simulate sliding.
		velocity.y += WALL_SLIDE_GRAVITY * delta
		if Input.is_action_just_pressed("ui_left") and not raycastRight.is_colliding():
			velocity = Vector2(-WALL_JUMP_HORIZONTAL_VELOCITY, JUMP_VELOCITY)
		elif Input.is_action_just_pressed("ui_right") and not raycastLeft.is_colliding():
			velocity = Vector2(WALL_JUMP_HORIZONTAL_VELOCITY, JUMP_VELOCITY)
	else:
		velocity.y += gravity * delta
		sprite.texture = falling_texture
		if canDoubleJump:
			if Input.is_action_just_pressed("ui_left") and not raycastRight.is_colliding():
				velocity = Vector2(-WALL_JUMP_HORIZONTAL_VELOCITY, JUMP_VELOCITY)
				canDoubleJump = false
			elif Input.is_action_just_pressed("ui_right") and not raycastLeft.is_colliding():
				velocity = Vector2(WALL_JUMP_HORIZONTAL_VELOCITY, JUMP_VELOCITY)
				canDoubleJump = false
		
			

	if is_on_floor():
		velocity.x = 0
		is_wall_jumping = false
		sprite.texture = normal_texture
		# Handle horizontal movement.
		if Input.is_action_just_pressed("ui_left") and not raycastRight.is_colliding():
			velocity.x = -SPEED
			velocity.y = JUMP_VELOCITY
		elif Input.is_action_just_pressed("ui_right") and not raycastLeft.is_colliding():
			velocity.x = SPEED
			velocity.y = JUMP_VELOCITY
	move_and_slide()
