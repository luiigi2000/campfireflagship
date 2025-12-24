extends Node2D

var speed := 50.0
var dragging = false
var offset = Vector2(0,0)
var limit = 100000
@onready var timer = $PointsTimer
var powerup2added = false
@export var powerup2_chance = 50
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if get_meta("type") == "food":
		for food in global.food_data.values():
			if food["name"] == get_meta("name"):
				$Points.text = "+" + str(food["points"])
				break
	timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for conveyer in global.conveyers.values():
		if conveyer["objects"].has(self):
			speed = conveyer["speed"]
			break
	if global.ice_debounce:
		for i in global.conveyers.keys():
			global.conveyers[i]["speed"] =  global.base_speed + (10 * len(global.conveyers[i]["objects"]))
	position.x += speed * delta
	if position.x >= get_viewport_rect().size.x:
		if get_meta("type") == "food":
			global.perfect_round = false
		if get_meta("type") == "ice":
			global.ice_debounce = false #add a timer to make it true again
			for conveyer in global.conveyers.values():
				if conveyer["objects"].has(self):
					conveyer["speed"] = 0
					break
			visible = false
			await get_tree().create_timer(2.0).timeout
			global.ice_debounce = true
		if get_meta("type") == "bomb":
			for conveyer in global.conveyers.values():
				if conveyer["objects"].size() > 0 and conveyer["objects"].has(self):
					conveyer["objects"].erase(self)
					queue_free()
					print("BOMB")
					for i in range(2):
						if conveyer["objects"].is_empty():
							break
						var obj = randi_range(0,len(conveyer["objects"])-1)
						conveyer["objects"][obj].queue_free()
						conveyer["objects"].remove_at(obj)

		for conveyer in global.conveyers.values():
			if conveyer["objects"].has(self):
				conveyer["objects"].erase(self)
				break
		queue_free()
	if dragging:
		position = get_global_mouse_position() - offset
		position = Vector2(clamp(position.x,20,limit),clamp(position.y,0,get_viewport_rect().size.y))
		
func _on_button_button_down() -> void:
	dragging = true
	limit = get_global_mouse_position().x +5
	offset = get_global_mouse_position() - global_position


func _on_button_button_up() -> void:
	if position.y < 250:
		if global.conveyers["conveyer2"]["objects"].has(self):
			global.conveyers["conveyer2"]["objects"].erase(self)
		if global.conveyers["conveyer3"]["objects"].has(self):
			global.conveyers["conveyer3"]["objects"].erase(self)
		if global.conveyers["conveyer1"]["objects"].has(self) == false:
			global.conveyers["conveyer1"]["objects"].append(self)
		set_meta("conveyer",1)
		position.y = 125
	elif position.y < 450:
		if global.conveyers["conveyer1"]["objects"].has(self):
			global.conveyers["conveyer1"]["objects"].erase(self)
		if global.conveyers["conveyer3"]["objects"].has(self):
			global.conveyers["conveyer3"]["objects"].erase(self)
		if global.conveyers["conveyer2"]["objects"].has(self) == false:
			global.conveyers["conveyer2"]["objects"].append(self)
		set_meta("conveyer",2)
		position.y = 350
	else:
		if global.conveyers["conveyer1"]["objects"].has(self):
			global.conveyers["conveyer1"]["objects"].erase(self)
		if global.conveyers["conveyer2"]["objects"].has(self):
			global.conveyers["conveyer2"]["objects"].erase(self)
		if global.conveyers["conveyer3"]["objects"].has(self) == false:
			global.conveyers["conveyer3"]["objects"].append(self)
		set_meta("conveyer",3)
		position.y = 575
	dragging = false
	limit = 1000000

func _on_points_timer_timeout() -> void:
	if dragging == false:
		for food in global.food_data.values():
			if food["name"] == get_meta("name"):
				global.Points += food["points"]
				break
		if get_meta("type") == "food":
			var count = randi_range(1,powerup2_chance)
			if count == 2:
				$Powerup2.text = "+" + str(global.powerup2_amnt-10)
				global.Points+=(global.powerup2_amnt-10)
				$Powerup2.visible = true
		$Points.visible = true
		await get_tree().create_timer(1.0).timeout
		$Points.visible = false
		$Powerup2.visible = false
	timer.start()
