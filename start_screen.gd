extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn")


func _on_select_difficulty_pressed() -> void:
	change_vis()


func _on1__pressed() -> void:
	global.base_speed = 25
	change_vis()


func _on2__pressed() -> void:
	global.base_speed = 50
	change_vis()


func _on3__pressed() -> void:
	global.base_speed = 300
	change_vis()


func _on4__pressed() -> void:
	global.base_speed = 400
	change_vis()
	
func change_vis():
	for i in $SelectDifficulty.get_children():
		if i.visible:
			i.visible = false
		else:
			i.visible = true
