extends CharacterBody3D

@onready var audio = $AudioStreamPlayer
const SPEED = 5.0
var JUMP_VELOCITY = 5.5
var GRAVITY = 9.8

var is_stuck_in_air = false
var stuck_y_position = 0.0

# Camera rotation and movement variables
var mouse_sensitivity = 0.002
var is_mouse_captured = false
var camera_vertical_offset = 0.0

# Flying variables
var max_jumps = 3
var current_jumps = 0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
				is_mouse_captured = true
			else:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				is_mouse_captured = false
	
	if event is InputEventMouseMotion and is_mouse_captured:
		$Camera_Controller.rotate_y(-event.relative.x * mouse_sensitivity)
		camera_vertical_offset -= event.relative.y * mouse_sensitivity
		camera_vertical_offset = clamp(camera_vertical_offset, -2.0, 2.0)

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("restart_game"):
		get_tree().change_scene_to_file("res://Scenes/level_1.tscn")
		
		
	if Input.is_action_just_pressed("cam_left"):
		$Camera_Controller.rotate_y(deg_to_rad(30))
	if Input.is_action_just_pressed("cam_right"):
		$Camera_Controller.rotate_y(deg_to_rad(-30))
	
	if Input.is_action_just_pressed("increase_jump"):
		JUMP_VELOCITY = 1.5 * JUMP_VELOCITY
	if Input.is_action_just_pressed("decrease_jump"):
		if JUMP_VELOCITY > 5.5:
			JUMP_VELOCITY = JUMP_VELOCITY / 1.5
		else:
			JUMP_VELOCITY = 5.5
	
	if Input.is_action_just_pressed("ui_f"):
		if is_stuck_in_air:
			is_stuck_in_air = false
		else:
			is_stuck_in_air = true
			stuck_y_position = global_transform.origin.y

	# Handle jumping
	if Input.is_action_just_pressed("ui_accept") and current_jumps < max_jumps:
		if current_jumps == 0:
			audio.play()
		velocity.y = JUMP_VELOCITY
		current_jumps += 1

	# Apply gravity when not stuck
	if not is_stuck_in_air:
		velocity.y -= GRAVITY * delta
	else:
		global_transform.origin.y = stuck_y_position
		velocity.y = 0

	# Reset jumps when on the floor
	if is_on_floor():
		current_jumps = 0

	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = ($Camera_Controller.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if input_dir != Vector2(0, 0):
		$MeshInstance3D.rotation_degrees.y = $Camera_Controller.rotation_degrees.y - rad_to_deg(input_dir.angle()) + 90
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	# Camera following
	$Camera_Controller.position.x = lerp($Camera_Controller.position.x, position.x, 0.15)
	$Camera_Controller.position.z = lerp($Camera_Controller.position.z, position.z, 0.15)
	$Camera_Controller.position.y = lerp($Camera_Controller.position.y, position.y + camera_vertical_offset, 0.15)

	move_and_slide()

func _on_fall_zone_body_entered(body: Node3D) -> void:
	
	get_tree().change_scene_to_file("res://Scenes/level_1.tscn")
