extends Node3D

func _ready() -> void:
	Global.coins = 0
	$Player.show()
	$AudioStreamPlayer.play()


func _on_audio_stream_player_finished() -> void:
	$AudioStreamPlayer.play()
