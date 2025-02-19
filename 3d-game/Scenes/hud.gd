extends CanvasLayer

@onready var time_label = $timer_label
@onready var timer = $Timer
@onready var restart_dialog = $RestartDialog
@onready var starter = $Starter
@onready var play_button = $Starter/PlayButton  # Adjust path if needed

var countdown_time = 322
var timer_running = false  # Don't start timer until Play is pressed

func _ready():
	starter.show()  # Show the Starter screen initially
	get_node("Panel").hide()
	get_node("TextureRect").hide()
	get_node("CoinsLabel").hide()
	get_node("Label").hide()
	get_node("timer_label").hide()


	$Win.hide()
	$Menu.hide()
	$Menu.process_mode = Node.PROCESS_MODE_ALWAYS
	$Win.process_mode = Node.PROCESS_MODE_ALWAYS

	timer.stop() 

	if timer:
		print("Timer node found!")
		timer.timeout.connect(_on_timer_timeout)  # Ensure the timer signal is connected


	# Connect Play button to start the game
	if play_button:
		play_button.pressed.connect(start_game)

	update_time_display()


func start_game():
	starter.hide()
	get_node("Panel").show()
	get_node("TextureRect").show()
	get_node("CoinsLabel").show()
	get_node("Label").show()
	get_node("timer_label").show()
	timer_running = true
	timer.start()
	get_tree().paused = false


#func reset_game_state():
	#timer_running = false
	#timer.stop()
	#update_time_display()
#
	#Global.coins = 0  
	#var player = get_tree().get_root().get_node("Level_1/Player")
	#if player:
		#print("asassa")
		#player.position = Vector2(100, 100)
#
	#$Win.hide()
	#$Menu.hide()
	#starter.show()

	

func _on_timer_timeout():
	if timer_running:
		if countdown_time > 0:
			countdown_time -= 1
			update_time_display()
		else:
			timer_running = false
			timer.stop()
			on_countdown_finished()

func update_time_display():
	if Global.coins >= Global.total_coin_count and Global.eggs >= Global.total_egg_count:
		get_tree().paused = true
		$Win.show()
		$Starter.hide()
	
	var minutes = countdown_time / 60
	var remaining_seconds = countdown_time % 60
	time_label.text = "Time Left: %02d:%02d" % [minutes, remaining_seconds]

func on_countdown_finished():
	time_label.text = "Time's Up!"
	print("Countdown finished!")
	get_tree().paused = true
	$Menu.show()
