extends Node2D

var debounce = true
var end_debounce = false
@onready var slot_images = $Slot_Images
var original_count = global.spin_amnt
var powerups
var choices = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global.leaderboard_stats[1] += 1
	reset_powerups()
	$ButtonScale/Button.text = str(original_count)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_button_pressed() -> void:
	$ButtonScale/Button.text = str(original_count-1)
	spin()
		
func _on_button1_pressed() -> void:
	if end_debounce:
		choose_powerup(choices[0])

func _on_button2_pressed() -> void:
	if end_debounce:
		choose_powerup(choices[1])

func _on_button3_pressed() -> void:
	if end_debounce:
		choose_powerup(choices[2])
	
func choose_powerup(chosen):
	global.leaderboard_stats[3] += 1
	if chosen == "power1":
		global.base_speed += 10
		for food in global.food_data.values():
			if food["name"]  != "ice"  and  food["name"] != "bomb":  #add type: food
				print(food["name"])
				food["points"] += 1
	elif chosen == "power2":
		global.powerup2_debounce = true
		global.powerup2_amnt += 10
	elif chosen == "power3":
		global.spin_amnt+=1
	elif chosen == "power4":
		for food in global.food_data.values():
			if food["name"]  != "ice"  and  food["name"] != "bomb":  #add type: food
				food["points"] *= 1.3
				food["points"] = roundi(food["points"])
	elif chosen == "power5":
		global.powerup5_debounce = true
	elif chosen == "power6":
		global.trash_storage += 1
	original_count -= 1
	if original_count > 0:
		debounce = true
		spin()
	else:
		await get_tree().create_timer(1).timeout
		global.Goal += 100
		if global.perfect_round:
			global.perfect_round = false
			global.Points = global.Goal/4
		else:
			global.Points = 0
		get_tree().change_scene_to_file("res://main.tscn")
	
func spin():
	reset_powerups()
	if debounce:
		debounce = false
		for slot in slot_images.get_children():
			for i in range(10):
				await get_tree().create_timer(.1).timeout
				var img_keys = powerups.keys()
				var key = img_keys.pick_random()
				slot.texture = powerups[key]["img"]
				slot.get_node("Label").text = powerups[key]["text"]
			
				if i == 9:
					choices.append(key)
		end_debounce = true
		
func reset_powerups():
	if global.powerup5_debounce:
		powerups = {
			"power1": {
				"img": load("res://images/wallywest.jpg"),
				"text": "conveyer gains + 10 speed for +1 points per food"
			},
			"power2": {
				"img": load("res://images/mining.jpg"),
				"text": "very low chance for a food to occationally give " + str(global.powerup2_amnt) + " points"
			},
			"power3": {
				"img": load("res://images/spinning.jpg"),
				"text": "+1 spin next round"
			},
			"power4": {
				"img": load("res://images/caseoh.jpg"),
				"text": "Slower metabolism: 3% gain for calories"
			},
			"power6": {
				"img": load("res://images/racoon.jpg"),
				"text": "add +1 storage to the trashcan capacity"
			}
		}
	else:
		powerups = {
			"power1": {
				"img": load("res://images/wallywest.jpg"),
				"text": "conveyer gains + 10 speed for +1 points per food"
			},
			"power2": {
				"img": load("res://images/mining.jpg"),
				"text": "very low chance for a food to occationally give " + str(global.powerup2_amnt) + " points"
			},
			"power3": {
				"img": load("res://images/spinning.jpg"),
				"text": "+1 spin next round"
			},
			"power4": {
				"img": load("res://images/caseoh.jpg"),
				"text": "Slower metabolism: 3% gain for calories"
			},
			"power5": {
				"img": load("res://images/icon.jpg"),
				"text": "Every time you lose a tobiko, your food lost capacity raises by 2 (does not stack)"
			},
			"power6": {
				"img": load("res://images/racoon.jpg"),
				"text": "add +1 storage to the trashcan capacity"
			}
		}
