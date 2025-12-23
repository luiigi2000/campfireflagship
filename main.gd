extends Node2D

#I attempted to make the code more efficient for about an hour to an hour and a half by using instances for the conveyers but it DID NOT WORK so dont blame me for this dooky ass code
@onready var timer := $SpawnTimer
@onready var spawners := $Spawners

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if global.Points >= 0:
		global.Points = 0
		for conveyer in global.conveyers.values():
			for object in conveyer["objects"]:
				object.queue_free()
			conveyer["objects"] = []
		get_tree().change_scene_to_file("res://slots.tscn")
			
	timer.wait_time = global.SpawnTime
	$Label.text = str(global.Points) + " calories"
	
	if Input.is_action_just_pressed("accessmenu"):
		if $menu.visible == false:
			$menu.visible = true
		else:
			$menu.visible = false
	
	$Background/Label.text = str(len(global.conveyers["conveyer1"]["objects"]))
	$Background/Label2.text = str(len(global.conveyers["conveyer2"]["objects"]))
	$Background/Label3.text = str(len(global.conveyers["conveyer3"]["objects"]))


func _on_spawn_timer_timeout() -> void:
	spawn()
	timer.start()


func spawn():
	var children = spawners.get_children()
	var count := randi_range(0,children.size()-1)
	var image := randi_range(1,5)
	var instance = preload("res://sushi.tscn").instantiate()
	if image == 1:
		instance.texture = load("res://images/download (1).jpg")
		instance.set_meta("type", "food")
		instance.set_meta("points", 1)
	elif image == 2:
		instance.texture = load("res://images/nigiri-sushi-1200.jpg")
		instance.scale = Vector2(.05,.05)
		instance.set_meta("type", "food")
		instance.set_meta("points", 2)
	elif image == 3:
		instance.texture = load("res://images/tobiko-roll-1200.jpg")
		instance.scale = Vector2(.05,.05)
		instance.set_meta("type", "food")
		instance.set_meta("points", 3)
	elif image == 4:
		instance.texture = load("res://images/images (1).jpg")
		instance.set_meta("points",0)
		instance.set_meta("type", "ice")
	elif image == 5:
		instance.texture = load("res://images/bomb.webp")
		instance.set_meta("points",0)
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
	
