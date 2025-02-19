extends CharacterBody3D

# Constants
const GRAVITY = 9.8

# Physics
@export var speed = 15.0 # (float, 10.0, 30.0)
@export var jump_height = 25.0 # (float, 10.0, 50.0)
@export var mass = 8.0 # (float, 1.0, 10.0)
@export var gravity_scl = 1.0 # (float, 0.1, 3.0, 0.1)

@onready var ground_ray = $GroundRay

var gravity_speed = 0
var walking = false
var rayCollider


func _ready():
	pass


func _physics_process(delta):
	# Gravity
	gravity_speed -= GRAVITY * gravity_scl * mass * delta
	
	var velocity = Vector3()
	velocity.y = gravity_speed
	set_velocity(velocity)
	set_up_direction(ground_ray.get_collision_normal())
	set_floor_stop_on_slope_enabled(true)
	move_and_slide()
	gravity_speed = velocity.y
	
