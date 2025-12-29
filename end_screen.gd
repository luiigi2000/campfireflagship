extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Leaderboard.text = "Food Lost: " + str(global.leaderboard_stats[0]) + "\n" + "Rounds Completed: " + str(global.leaderboard_stats[1]) + "\n" + "Perfect Rounds: "  + str(global.leaderboard_stats[2]) + "\n" + "Powerups Bought: " + str(global.leaderboard_stats[3]) + "\n" + "Calories Gained: " + str(global.leaderboard_stats[4])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_button_pressed() -> void:
	global.reset()
	get_tree().change_scene_to_file("res://main.tscn")
