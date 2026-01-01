extends Node2D

#I attempted to make the code more efficient for about an hour to an hour and a half by using instances for the conveyers but it DID NOT WORK so dont blame me for this dooky ass code
@onready var timer := $SpawnTimer
@onready var spawners := $Spawners
var round_done := false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if round_done:
		return
	if global.Points >= global.Goal:
		round_done = true
		global.leaderboard_stats[4] += global.Points
		for conveyer in global.conveyers.values():
			for object in conveyer["objects"]:
				object.queue_free()
			conveyer["objects"].clear()
		if global.perfect_round == true:
			global.leaderboard_stats[2] += 1
			global.total_score += global.Goal
			$PerfectRound.visible = true
			await get_tree().create_timer(1).timeout
			$PerfectRound.visible = false
		get_tree().call_deferred("change_scene_to_file", "res://slots.tscn")
			
	timer.wait_time = global.SpawnTime
	$Label.text = str(global.Points) + " / " + str(global.Goal) + " calories"
	
	if Input.is_action_just_pressed("accessmenu"):
		if $menu.visible == false:
			$menu.visible = true
		else:
			$menu.visible = false
	
	
	$Background/Label.text = str(len(global.conveyers["conveyer1"]["objects"]))
	$Background/Label2.text = str(len(global.conveyers["conveyer2"]["objects"]))
	$Background/Label3.text = str(len(global.conveyers["conveyer3"]["objects"]))
	$FoodLost.text = str(global.food_lost) + "/" + str(global.lost_limit)
	
	if global.food_lost >= global.lost_limit:
		global.leaderboard_stats[4] += global.Points
		get_tree().change_scene_to_file("res://end_screen.tscn")


func _on_spawn_timer_timeout() -> void:
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
		instance.texture = global.food_data["tobiko"]["image"]
		instance.scale = Vector2(.05,.05)
		instance.set_meta("type", "food")
		instance.set_meta("name","tobiko")
	elif image <= 80:
		instance.texture = load("res://images/images (1).jpg")
		instance.set_meta("name","ice")
		instance.set_meta("type", "ice")
	elif image <= 100:
		instance.scale = Vector2(.05,.05)
		instance.texture = load("res://images/bomb.webp")
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
	


func _on_conveyer_1_collision_mouse_entered() -> void:
	global.mouse_location = 1
	print("E")

func _on_conveyer_2_collision_mouse_entered() -> void:
	global.mouse_location = 2


func _on_conveyer_3_collision_mouse_entered() -> void:
	global.mouse_location = 3


func _on_trash_can_collision_mouse_entered() -> void:
	global.mouse_location = 4
