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
var line := Line2D.new()
var ready_to_delete := false
var dir
var fell_debounce := false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	line.top_level = true
	set_meta("line",line)
	add_child(line)
	if get_meta("type") == "food":
		for food in global.food_data.values():
			if food["name"] == get_meta("name"):
				$Points.text = "+" + str(food["points"])
				break
	timer.start()
	##this makes sure it wont delete right after spawn on the the right for bonus round2
	await get_tree().create_timer(1.5).timeout
	ready_to_delete = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for conveyer in global.conveyers.values():
		if conveyer["objects"].has(self):
			speed = conveyer["speed"]
			break
	if global.bonus_round[0] and line != null and not (get_meta("brother_if_tied") is NodePath):
		line.width = 3
		line.points = [global_position,get_meta("brother_if_tied").global_position]
	if global.ice_debounce:
		for i in global.conveyers.keys():
			global.conveyers[i]["speed"] =  global.base_speed * global.conveyers[i]["direction"] + (10 * len(global.conveyers[i]["objects"]) * global.conveyers[i]["direction"])
	if not fell_debounce:
		position.x += speed * delta
	if (position.x >= get_viewport_rect().size.x or position.x <= 0) and ready_to_delete:
		if global.bonus_round[0] and line != null:
			get_meta("brother_if_tied").position.x = get_viewport_rect().size.x + 5
			line.queue_free()
		if get_meta("type") == "food":
			lose_food()
		if get_meta("name") == "tobiko" and global.powerup5_debounce:
			global.lost_limit += 2
		if get_meta("type") == "ice":
			global.ice_debounce = false #add a timer to make it true again
			var chosen_conveyer
			for conveyer in global.conveyers.values():
				if conveyer["objects"].has(self):
					chosen_conveyer = conveyer
					for object in conveyer["objects"]:
						if object != null:
							object.modulate = Color(0,1,1)
					conveyer["speed"] = 0
					break
			visible = false
			await get_tree().create_timer(2.0).timeout
			global.ice_debounce = true
			for object in chosen_conveyer["objects"]:
				object.modulate = Color(1,1,1)
		if get_meta("type") == "bomb":
			for conveyer in global.conveyers.values():
				if conveyer["objects"].size() > 0 and conveyer["objects"].has(self):
					conveyer["objects"].erase(self)
					queue_free()
					for i in range(2):
						if conveyer["objects"].is_empty():
							break
						var obj = randi_range(0,len(conveyer["objects"])-1)
						if not is_instance_valid(conveyer["objects"][obj]):
							conveyer["objects"].remove_at(obj)
							i-=1
							continue
						if conveyer["objects"][obj].get_meta("type") == "food":
							lose_food()
						if global.bonus_round[0]:
							conveyer["objects"][obj].get_meta("line").queue_free()
							conveyer["objects"][obj].get_meta("brother_if_tied").get_meta("line").queue_free()
							conveyer["objects"][obj].get_meta("brother_if_tied").position.x = get_viewport_rect().size.x + 5
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
		if global.bonus_round[1]:
			if dir == "left":
				position = Vector2(clamp(position.x,limit,get_viewport_rect().size.x-20),clamp(position.y,0,get_viewport_rect().size.y))
			else:
				position = Vector2(clamp(position.x,20,limit),clamp(position.y,0,get_viewport_rect().size.y))
		else:
			position = Vector2(clamp(position.x,20,limit),clamp(position.y,0,get_viewport_rect().size.y))
		
func _on_button_button_down() -> void:
	if global.bonus_round[1]:
		for i in global.conveyers.values():
			if i["objects"].has(self):
				if i["direction"] == -1:
					dir = "left"
					limit = get_global_mouse_position().x - 5
				else:
					limit = get_global_mouse_position().x + 5
					dir = "right"
				break
	else:
		limit = get_global_mouse_position().x + 5
	$Button.mouse_filter = Control.MOUSE_FILTER_PASS
	click_timer.start()
	if not fell_debounce:
		dragging = true
	offset = get_global_mouse_position() - global_position


func _on_button_button_up() -> void:
	if click_timer.is_stopped() == false:
		click_timer.stop()
	$Button.mouse_filter = Control.MOUSE_FILTER_STOP
	move_to_conveyer()
	dragging = false
	limit = 1000000

func _on_points_timer_timeout() -> void:
	if dragging == false and not fell_debounce:
		for food in global.food_data.values():
			if food["name"] == get_meta("name"):
				print(food["name"]+" "+get_meta("name"))
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
	move_to_conveyer()
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

func lose_food():
	global.perfect_round = false
	global.food_lost += 1
	global.leaderboard_stats[0] += 1
	
func move_to_conveyer():
	if not fell_debounce:
		if global.mouse_location == 1:
			move_conveyer(global.conveyers["conveyer2"]["objects"],global.conveyers["conveyer3"]["objects"],global.conveyers["conveyer1"]["objects"],1,180.0)
		elif global.mouse_location == 2:
			move_conveyer(global.conveyers["conveyer1"]["objects"],global.conveyers["conveyer3"]["objects"],global.conveyers["conveyer2"]["objects"],2,323.0)
		elif global.mouse_location == 3:
			move_conveyer(global.conveyers["conveyer1"]["objects"],global.conveyers["conveyer2"]["objects"],global.conveyers["conveyer3"]["objects"],3,470.0)
		elif global.mouse_location == 4 and global.trash_stored < global.trash_storage:
			global.trash_stored += 1
			for conveyer in global.conveyers.values():
				if conveyer["objects"].has(self):
					conveyer["objects"].erase(self)
					if global.bonus_round[0]  and not (get_meta("brother_if_tied") is NodePath):
						get_meta("brother_if_tied").queue_free()
					break
			queue_free()
		else:
			fell_debounce = true
			for conveyer in global.conveyers.values():
				if conveyer["objects"].has(self):
					conveyer["objects"].erase(self)
					break
			modulate = Color.GREEN
			lose_food()
			await get_tree().create_timer(1.5).timeout
			queue_free()
		
		
	
