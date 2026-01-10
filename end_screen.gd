extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup_leaderboard()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_button_pressed() -> void:
	global.reset()
	get_tree().change_scene_to_file("res://main.tscn")
	
func setup_leaderboard():
	var total_score = global.total_score + global.leaderboard_stats[4]
	global.podium_scores.append(total_score)
	global.podium_scores.sort()
	global.podium_scores.reverse()
	var count = 0
	if len(global.podium_scores) <= 3:
		for i in range(3):
			count += 1
			if i < len(global.podium_scores):
				$Leadboard.text = $Leadboard.text + "\n" + str(count) + ": " + str(global.podium_scores[i])
			else:
				$Leadboard.text = $Leadboard.text + "\n" + str(count) + ":" 			
	else:
		global.podium_scores.remove_at(len(global.podium_scores)-1)
		for i in range(3):
			count += 1
			$Leadboard.text = $Leadboard.text + "\n" + str(count) + ": " + str(global.podium_scores[i])
	
	$Score.text = "Score: " + str(total_score) #calculated by the calories plus the goal amount for each perfect round
	$Stats.text = "Food Lost: " + str(global.leaderboard_stats[0]) + "\n" + "Rounds Completed: " + str(global.leaderboard_stats[1]) + "\n" + "Perfect Rounds: "  + str(global.leaderboard_stats[2]) + "\n" + "Powerups Bought: " + str(global.leaderboard_stats[3]) + "\n" + "Calories Gained: " + str(global.leaderboard_stats[4])
