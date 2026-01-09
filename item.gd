extends Button

var dragging := false
var parent
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if get_meta("item") == 0:
		icon = load("res://images/Sushi/nigiri.png")
		text = "1"
	elif get_meta("item") == 1:
		icon = load("res://images/Sushi/caliroll-export-export.png")
		text = "2"
	elif get_meta("item") == 2:
		icon = load("res://images/Sushi/tempura.png")
		text = "3"
	parent = get_parent()

func _process(delta: float) -> void:
	if dragging:
		global_position = get_global_mouse_position()

func start_drag():
	reparent(get_tree().current_scene, true)
	dragging = true
	
func end_drag():
	reparent(parent, true)
	dragging = false
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				call_deferred("start_drag")
			else:
				end_drag()
