extends Sprite3D

var coins = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	#print("Hi")



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#pass
	if Input.is_action_pressed("ui_left"):
		rotate_y(0.1)
	#rotate_x(0.1)
