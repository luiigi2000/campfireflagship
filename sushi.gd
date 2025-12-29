extends Node2D

var speed := 50.0
var dragging = false
var offset = Vector2(0,0)
var limit = 100000
@onready var timer = $PointsTimer
var powerup2added = false
@export var powerup2_chance = 50
@onready var click_timer = $ClickTimer
var timeout_debounce = true
var time_freeze := 2.5
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
			global.food_lost += 1
		if get_meta("name") == "tobiko" and global.powerup5_debounce:
			global.lost_limit += 2
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
					for i in range(2):
						if conveyer["objects"].is_empty():
							break
						var obj = randi_range(0,len(conveyer["objects"])-1)
						if conveyer["objects"][obj].get_meta("type") == "food":
							global.food_lost += 1
						conveyer["objects"][obj].queue_free()
						conveyer["objects"].remove_at(obj)

		for conveyer in global.conveyers.values():
			if conveyer["objects"].has(self):
				conveyer["objects"].erase(self)
				break
		queue_free()
		return
	if dragging and timeout_debounce:
		position = get_global_mouse_position() - offset
		position = Vector2(clamp(position.x,20,limit),clamp(position.y,0,get_viewport_rect().size.y))
		
func _on_button_button_down() -> void:
	click_timer.start()
	dragging = true
	limit = get_global_mouse_position().x +5
	offset = get_global_mouse_position() - global_position


func _on_button_button_up() -> void:
	if click_timer.is_stopped() == false:
		click_timer.stop()

	if position.y < 250:
		move_conveyer(global.conveyers["conveyer2"]["objects"],global.conveyers["conveyer3"]["objects"],global.conveyers["conveyer1"]["objects"],1,125)
	elif position.y < 450:
		move_conveyer(global.conveyers["conveyer1"]["objects"],global.conveyers["conveyer3"]["objects"],global.conveyers["conveyer2"]["objects"],2,350)
	else:
		move_conveyer(global.conveyers["conveyer1"]["objects"],global.conveyers["conveyer2"]["objects"],global.conveyers["conveyer3"]["objects"],3,575)
	dragging = false
	limit = 1000000

func _on_points_timer_timeout() -> void:
	if dragging == false:
		for food in global.food_data.values():
			if food["name"] == get_meta("name"):
				global.Points += food["points"]
				break
		if get_meta("type") == "food" and global.powerup2_debounce:
			var count = randi_range(1,2)#2=powerup2_chance
			if count == 2:
				$Powerup2.text = "+" + str(global.powerup2_amnt-10)
				global.Points+=(global.powerup2_amnt-10)
				$Powerup2.visible = true
		$Points.visible = true
		await get_tree().create_timer(1.0).timeout
		$Points.visible = false
		$Powerup2.visible = false
	timer.start()
	

func _on_click_timer_timeout() -> void:
	dragging = false
	if position.y < 250:
		move_conveyer(global.conveyers["conveyer2"]["objects"],global.conveyers["conveyer3"]["objects"],global.conveyers["conveyer1"]["objects"],1,125)
	elif position.y < 450:
		move_conveyer(global.conveyers["conveyer1"]["objects"],global.conveyers["conveyer3"]["objects"],global.conveyers["conveyer2"]["objects"],2,350)
	else:
		move_conveyer(global.conveyers["conveyer1"]["objects"],global.conveyers["conveyer2"]["objects"],global.conveyers["conveyer3"]["objects"],3,575)
	limit = 1000000
	timeout_debounce = false
	await get_tree().create_timer(time_freeze).timeout
	timeout_debounce = true
	
func move_conveyer(conveyer1,conveyer2,conveyerself,conveyernum,ypos):
	if conveyer1.has(self):
		conveyer1.erase(self)
	if conveyer2.has(self):
		conveyer2.erase(self)
	if conveyerself.has(self) == false:
		conveyerself.append(self)
	set_meta("conveyer",conveyernum)
	position.y = ypos	
