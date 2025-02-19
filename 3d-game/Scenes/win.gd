extends Control

func _on_play_again_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/level_1.tscn")


func _on_close_pressed() -> void:
	get_tree().paused = false
	get_tree().quit()
