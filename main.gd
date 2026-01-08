extends Node2D

#I attempted to make the code more efficient for about an hour to an hour and a half by using instances for the conveyers but it DID NOT WORK so dont blame me for this dooky ass code
@onready var timer := $SpawnTimer
@onready var spawners := $Spawners
var round_done := false
var conveyers_effected = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_level_display()
	if global.round%3==0:
		global.bonus_round[randi_range(0,len(global.bonus_round)-1)] = true
	else:
		for v in global.bonus_round:
			v = true
	if global.bonus_round[1]:
		stagger_conveyers()
	global.trash_stored = 0
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	timer.start()
	$ConveyerMultiplier.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if round_done:
		return
	conveyer_multiply()
	if global.Points >= global.Goal:
		end_round()
			
	timer.wait_time = global.SpawnTime
	$LevelDisplay/Label.text = str(global.Points) + " / " + str(global.Goal) + " calories"
	
	if Input.is_action_just_pressed("accessmenu"):
		if $menu.visible == false:
			$menu.visible = true
		else:
			$menu.visible = false
	
	
	$Background/Label.text = str(len(global.conveyers["conveyer1"]["objects"]))
	$Background/Label2.text = str(len(global.conveyers["conveyer2"]["objects"]))
	$Background/Label3.text = str(len(global.conveyers["conveyer3"]["objects"]))
	$LevelDisplay/FoodLost.text = str(global.food_lost) + "/" + str(global.lost_limit)
	$Trashcan/TrashLabel.text = str(global.trash_storage - global.trash_stored)
	
	if global.food_lost >= global.lost_limit:
		global.leaderboard_stats[4] += global.Points
		get_tree().change_scene_to_file("res://end_screen.tscn")


func _on_spawn_timer_timeout() -> void:
	if global.bonus_round[0]:
		tie_foods()
	else:
		spawn()
	timer.start()

func spawn():
	var children = spawners.get_children()
	var count := randi_range(0,children.size()-1)
	var image := randi_range(1,100)
	var instance = preload("res://sushi.tscn").instantiate()
	if image <= 20:
		instance.texture = global.food_data["californiaroll"]["image"]
		instance.set_meta("type", "food")
		instance.set_meta("name","californiaroll")
	elif image <= 40:
		instance.texture = global.food_data["nigiri"]["image"]
		instance.scale = Vector2(.05,.05)
		instance.set_meta("type", "food")
		instance.set_meta("name","nigiri")
	elif image <= 60:
		instance.texture = global.food_data["tempura"]["image"]
		instance.scale = Vector2(.4,.4)
		instance.set_meta("type", "food")
		instance.set_meta("name","tempura")
	elif image <= 80:
		instance.texture = global.food_data["ice"]["image"]
		instance.set_meta("name","ice")
		instance.set_meta("type", "ice")
	elif image <= 100:
		instance.scale = Vector2(.05,.05)
		instance.texture = global.food_data["bomb"]["image"]
		instance.set_meta("name","bomb")
		instance.set_meta("type", "bomb")
		
	if count == 0:
		global.conveyers["conveyer1"]["objects"].append(instance)
		instance.set_meta("conveyer",1)
	elif count == 1:
		global.conveyers["conveyer2"]["objects"].append(instance)
		instance.set_meta("conveyer",2)
	else:
		global.conveyers["conveyer3"]["objects"].append(instance)
		instance.set_meta("conveyer",3)
	add_child(instance)
	instance.position = children[count].position
	return instance
	
func tie_foods():
	var brothers = []
	while true:
		if brothers.is_empty():
			for i in range(2):
				brothers.append(spawn())
		elif brothers[0].position != brothers[1].position:
			break
		else:
			for conveyer in global.conveyers.values():
				if conveyer["objects"].has(brothers[0]):
					conveyer["objects"].erase(brothers[0])
					brothers[0].queue_free()
					return
			for conveyer in global.conveyers.values():
				if conveyer["objects"].has(brothers[1]):
					conveyer["objects"].erase(brothers[1])
					brothers[1].queue_free()
					return
			brothers.clear()
			for i in range(2):
				brothers.append(spawn())
	brothers[0].set_meta("brother_if_tied", brothers[1])
	brothers[1].set_meta("brother_if_tied", brothers[0])

func _on_conveyer_1_collision_mouse_entered() -> void:
	global.mouse_location = 1

func _on_conveyer_2_collision_mouse_entered() -> void:
	global.mouse_location = 2


func _on_conveyer_3_collision_mouse_entered() -> void:
	global.mouse_location = 3


func _on_trash_can_collision_mouse_entered() -> void:
	global.mouse_location = 4
	
func conveyer_multiply():
	conveyers_effected = 0
	var effected = []
	for conveyer in global.conveyers:
		var names = ["nigiri", "tempura", "californiaroll"]
		var dupes = {
			"nigiri": 0,
			"tempura": 0,
			"californiaroll": 0
		}
		for i in global.conveyers[conveyer]["objects"]:
			if i != null:
				var name = i.get_meta("name")
				if names.has(name):
					dupes[name] += 1
		for i in dupes.values():
			if i == 3:
				conveyers_effected += 1
				var capitalized = conveyer[0].to_upper() + conveyer.substr(1)
				effected.append(capitalized)
	if effected.has("Conveyer1"):
		$Background/Conveyer1.modulate = Color(1,1,0)
	else:
		$Background/Conveyer1.modulate = Color(1,1,1)
	if effected.has("Conveyer2"):
		$Background/Conveyer2.modulate = Color(1,1,0)
	else:
		$Background/Conveyer2.modulate = Color(1,1,1)
	if effected.has("Conveyer3"):
		$Background/Conveyer3.modulate = Color(1,1,0)
	else:
		$Background/Conveyer3.modulate = Color(1,1,1)
	
func _on_conveyer_multiplier_timeout() -> void:
	global.Points += (global.conveyer_additives * conveyers_effected)
	$ConveyerMultiplier.start()
	
func end_round():
	round_done = true
	global.leaderboard_stats[4] += global.Points
	for conveyer in global.conveyers.values():
		for object in conveyer["objects"]:
			if object != null:
				object.queue_free()
		conveyer["objects"].clear()
	if global.perfect_round == true:
		global.leaderboard_stats[2] += 1
		global.total_score += global.Goal
		$PerfectRound.visible = true
		await get_tree().create_timer(1).timeout
		$PerfectRound.visible = false
	get_tree().call_deferred("change_scene_to_file", "res://slots.tscn")
	
func stagger_conveyers():
	for i in range(3):
		var count = randi_range(1,2)
		if count == 1:
			$Spawners.get_child(i).position.x = -$Spawners.get_child(i).position.x + get_viewport_rect().size.x
			global.conveyers[global.conveyers.keys()[i]]["direction"] = -1





func _on_conveyer_1_collision_mouse_exited() -> void:
	global.mouse_location = 0


func _on_conveyer_2_collision_mouse_exited() -> void:
	global.mouse_location = 0


func _on_trash_can_collision_mouse_exited() -> void:
	global.mouse_location = 0


func _on_conveyer_3_collision_mouse_exited() -> void:
	global.mouse_location = 0

func set_level_display():
	var next_round = global.round + 1
	var display_images = $LevelDisplay/Background/DisplayImages
	for i in range(display_images.get_child_count()):
		if not (next_round%3 == 0):
			display_images.get_child(i).texture = load("res://images/DisplayImages/regstar.png")
		else:
			display_images.get_child(i).texture = load("res://images/DisplayImages/star.jpg")
		next_round+=1
