extends Label


func _ready() -> void:
	$".".text = str(Global.eggs)


func _process(delta: float) -> void:
	$".".text = str(Global.eggs) + " / " + str(Global.total_egg_count)
