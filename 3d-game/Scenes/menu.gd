extends Control


func _on_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/level_1.tscn")  # Reloads the scene from the beginning


func _on_quit_pressed() -> void:
	get_tree().paused = false
	get_tree().quit()
