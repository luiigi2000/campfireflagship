extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup_leaderboard()
	set_up_peggle()
	drop_food()


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

func set_up_peggle():
	var peg = $Peggle/Peg.duplicate()
	$Peggle/Peg.queue_free()
	var y = peg.position.y
	var count = 0
	while y < get_viewport_rect().size.y - peg.get_node("MeshInstance2D").scale.y:
		var x = peg.position.x
		while x < ($Peggle/Side2.position.x-$Peggle/Side2.scale.x/2) - peg.get_node("MeshInstance2D").scale.x:
			if count%2==0:
				var new_peg = peg.duplicate()
				new_peg.position = Vector2(x,y)
				add_child(new_peg)
			x+=peg.get_node("MeshInstance2D").scale.x*2
			count+=1
		x = peg.position.x
		count+=1
		y += peg.get_node("MeshInstance2D").scale.y*2
		
func drop_food():
	var food = $Peggle/Food.duplicate()
	var textures = [load("res://images/Sushi/caliroll-export-export.png"),load("res://images/Sushi/nigiri.png"),load("res://images/Sushi/tempura.png")]
	$Peggle/Food.queue_free()
	
	for i in range(global.food_saved):
		await get_tree().create_timer(.25).timeout
		var clone = food.duplicate()
		clone.position = Vector2(randi_range($Peggle/Side1.position.x+$Peggle/Side1.scale.x/2,$Peggle/Side2.position.x-$Peggle/Side2.scale.x/2),0)
		clone.get_node("Sprite2D").texture = textures.pick_random()
		add_child(clone)	
	
	
