extends Node2D

var speed = global.Speed
var dragging = false
var offset = Vector2(0,0)
var limit = 100000
@onready var timer = $PointsTimer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x += speed * delta
	if position.x >= get_viewport_rect().size.x:
		queue_free()
	if dragging:
		position = get_global_mouse_position() - offset
		position = Vector2(clamp(position.x,0,limit),clamp(position.y,0,get_viewport_rect().size.y))

func _on_button_button_down() -> void:
	dragging = true
	limit = get_global_mouse_position().x +5
	offset = get_global_mouse_position() - global_position


func _on_button_button_up() -> void:
	if position.y < 250:
		position.y = 125
	elif position.y < 450:
		position.y = 350
	else:
		position.y = 575
	dragging = false
	limit = 1000000


func _on_points_timer_timeout() -> void:
	global.Points += get_meta("points")
	timer.start()
