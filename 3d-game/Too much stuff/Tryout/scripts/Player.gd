extends CharacterBody3D

# Constants
const GRAVITY = 9.8

# Mouse sensitivity
@export var sensitivity_x = 0.5 # (float, 0.1, 1.0)
@export var sensitivity_y = 0.4 # (float, 0.1, 1.0)

# Physics
@export var speed = 15.0 # (float, 10.0, 30.0)
@export var jump_height = 25.0 # (float, 10.0, 50.0)
@export var mass = 8.0 # (float, 1.0, 10.0)
@export var gravity_scl = 1.0 # (float, 0.1, 3.0, 0.1)

# Instances ref
@onready var player_cam = $Camera3D
@onready var ground_ray = $GroundRay

# Variables (public members)
var mouse_motion = Vector2()
var gravity_speed = 0
var mouse_captured = true


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	ground_ray.enabled = true
	pass

#func _unhandled_input(event):
#	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
#		player_cam.rotate_x(-event.relative.y * 0.002)
#		rotate_y(-event.relative.x * 0.002)
#		player_cam.rotation.x = clamp(player_cam.rotation.x, -1.2, 1.2)

func _physics_process(delta):
	
	# Camera and Body rotation
#	rotate_y(deg2rad(20)* - mouse_motion.x * sensitivity_x * delta)
#	player_cam.rotate_x(deg2rad(20)* - mouse_motion.y * sensitivity_y * delta)
#	player_cam.rotation.x = clamp(player_cam.rotation.x, deg2rad(-47), deg2rad(47))
#	mouse_motion = Vector2()
	
	# Gravity
	gravity_speed -= GRAVITY * gravity_scl * mass * delta
	
	# Character moviment
	var velocity = Vector3()
	velocity = _axis() * speed
	if Input.is_key_pressed(KEY_SHIFT):
		velocity.x *= 1.5
		velocity.z *= 1.5
	velocity.y = gravity_speed
	# To not fall from slopes when stop move
	if ground_ray.is_colliding() and not Input.is_key_pressed(KEY_W) and not Input.is_key_pressed(KEY_S) and not Input.is_key_pressed(KEY_A) and not Input.is_key_pressed(KEY_D):
		velocity.y = 0.0
#	print(velocity)
	
	# Jump
	if Input.is_action_just_pressed("aJump") and ground_ray.is_colliding():  # Needs to be setted on Project Settings -> InputMap
		velocity.y = jump_height
		
	set_velocity(velocity)
	set_up_direction(ground_ray.get_collision_normal())
	set_floor_stop_on_slope_enabled(true)
	move_and_slide()
	gravity_speed = velocity.y
	
	
	

func _input(event):
	if event is InputEventMouseMotion:
		mouse_motion = event.relative
	
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		player_cam.rotate_x(-event.relative.y * 0.002)
		rotate_y(-event.relative.x * 0.002)
		player_cam.rotation.x = clamp(player_cam.rotation.x, -1.2, 1.2)
	
	# Scene reset
	if Input.is_action_just_pressed("aSceneReset"):
		get_tree().reload_current_scene()
	
	if Input.is_action_just_pressed("Tgl_Mouse_Capture"):  # Toggle mouse captured
		if mouse_captured:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			mouse_captured = false
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			mouse_captured = true
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and !mouse_captured:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		mouse_captured = true
	
		

func _axis():
	var direction = Vector3()
	
#	if Input.is_key_pressed(KEY_W):
	if Input.is_action_pressed("aMoveForward"):  # Needs to be setted on Project Settings -> InputMap
		direction -= get_global_transform().basis.z.normalized()
	
#	if Input.is_key_pressed(KEY_S):
	if Input.is_action_pressed("aMoveBackward"):  # Needs to be setted on Project Settings -> InputMap
		direction += get_global_transform().basis.z.normalized()
	
#	if Input.is_key_pressed(KEY_A):
	if Input.is_action_pressed("aMoveLeft"):  # Needs to be setted on Project Settings -> InputMap
		direction -= get_global_transform().basis.x.normalized()
	
#	if Input.is_key_pressed(KEY_D):
	if Input.is_action_pressed("aMoveRight"):  # Needs to be setted on Project Settings -> InputMap
		direction += get_global_transform().basis.x.normalized()
	
	return direction.normalized()
