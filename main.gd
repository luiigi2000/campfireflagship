extends Node2D

@onready var timer := $SpawnTimer
@onready var spawners := $Spawners

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_spawn_timer_timeout() -> void:
	spawn()
	timer.start()

func spawn():
	var children = spawners.get_children()
	var count := randi_range(0,children.size()-1)
	var image := randi_range(1,3)
	var instance = preload("res://sushi.tscn").instantiate()
	if image == 1:
		instance.get_node("Image").texture = load("res://images/download (1).jpg")
		instance.set_meta("type", 1)
	elif image == 2:
		instance.get_node("Image").texture = load("res://images/nigiri-sushi-1200.jpg")
		instance.set_meta("type", 1)
	elif image == 3:
		instance.get_node("Image").texture = load("res://images/tobiko-roll-1200.jpg")
		instance.set_meta("type", 1)
	
	add_child(instance)
	instance.position = children[count].position
