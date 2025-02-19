extends Area3D



func _on_body_entered(body: Node3D) -> void:
	Global.eggs += 1
	if Global.coins == Global.total_coin_count and Global.eggs == Global.total_egg_count:
		get_tree().change_scene_to_file("res://Scenes/level_1.tscn")
	
	$AnimationPlayer.play("egg_bounce")



func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()
