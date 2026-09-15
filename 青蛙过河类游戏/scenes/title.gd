extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Label2.text = "High core : "+str(Global.score)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("confirm"):
		get_tree().change_scene_to_file("res://scenes/game.tscn")
