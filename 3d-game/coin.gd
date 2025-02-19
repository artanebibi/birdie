extends Area3D


const ROT_SPEED = 2
const TOTAL_NUM_COINS = 6

func _process(delta: float) -> void:
	rotate_y(deg_to_rad(ROT_SPEED))
	
func _on_body_entered(body: Node3D) -> void:
	Global.coins += 1
	print(Global.coins)
	if Global.coins == Global.total_coin_count and Global.eggs == Global.total_egg_count:
		#Global.coins = 0
		get_tree().change_scene_to_file("res://Scenes/level_1.tscn")
	$AnimationPlayer.play("bounce")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()
