extends Control

@onready var panel = get_node("../Panel")
@onready var text_rect = get_node("../TextureRect")
@onready var coins_label = get_node("../CoinsLabel")




func _process(delta: float) -> void:
	pass
	
	
func _on_play_pressed() -> void:
	get_tree().paused = false
	var level = get_tree().current_scene  
	var hud = level.get_node("HUD") 
	if hud:
		hud.start_game() 

	# Hide the starter screen
	
	#get_node("../Panel").show()
	#get_node("../TextureRect").show()
	#get_node("../CoinsLabel").show()
	#get_node("../Label").show()
	#get_node("../timer_label").show()
	#get_node("../Menu").hide()
	#get_node("../Win").hide()
	#hide()
	
	
