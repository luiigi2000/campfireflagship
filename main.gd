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
	var instance = spawners.get_meta("Spawnables")[0].instantiate()
	add_child(instance)
	instance.position = children[count].position
