extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var total_score = global.total_score + global.leaderboard_stats[4]
	global.podium_scores.append(total_score)
	global.podium_scores.sort()
	var count = 0
	if len(global.podium_scores) <= 3:
		for i in range(len(global.podium_scores) - 1, -1, -1):
			count += 1
			$Leadboard.text = $Leadboard.text + "\n" + str(count) + ": " + str(global.podium_scores[i])
	else:
		global.podium_scores.remove_at(0)
		for i in range(len(global.podium_scores) - 1, -1, -1):
			count += 1
			$Leadboard.text = $Leadboard.text + "\n" + str(count) + ": " + str(global.podium_scores[i])
			
	if len(global.podium_scores) == 1:
		$Leadboard.text = "1: " + global.podium_scores[3]
	elif len(global.podium_scores) == 2:
		$Leadboard.text = "1: " + global.podium_scores[2] + "n"
	
	$Score.text = "Score: " + str(total_score) #calculated by the calories plus the goal amount for each perfect round
	$Stats.text = "Food Lost: " + str(global.leaderboard_stats[0]) + "\n" + "Rounds Completed: " + str(global.leaderboard_stats[1]) + "\n" + "Perfect Rounds: "  + str(global.leaderboard_stats[2]) + "\n" + "Powerups Bought: " + str(global.leaderboard_stats[3]) + "\n" + "Calories Gained: " + str(global.leaderboard_stats[4])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_button_pressed() -> void:
	global.reset()
	get_tree().change_scene_to_file("res://main.tscn")
