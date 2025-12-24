extends Node2D

var debounce = true
var end_debounce = false
@onready var slot_images = $Slot_Images
var original_count = global.spin_amnt
var powerups = {
	"power1": {
		"img": load("res://images/steven.jpg"),
		"text": "conveyer gains + 10 speed for +1 points per food"
	},
	"power2": {
		"img": load("res://images/tyler.jpg"),
		"text": "very low chance for a food to occationally give " + str(global.powerup2_amnt) + " points"
	},
	"power3": {
		"img": load("res://images/hottie.jpg"),
		"text": "+1 spin next round"
	},
	"power4": {
		"img": load("res://images/josh.jpg"),
		"text": "Slower metabolism: 3% gain for calories"
	}
}
var choices = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Button.text = str(original_count)
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_button_pressed() -> void:
	$Button.text = str(original_count-1)
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
	original_count -= 1
	if original_count > 0:
		debounce = true
		spin()
	else:
		await get_tree().create_timer(1).timeout
		global.Goal += 5
		get_tree().change_scene_to_file("res://main.tscn")
	
func spin():
	powerups = { #move to process if tylers 10 doesnt update within the same scene (multiple spins)
		"power1": {
			"img": load("res://images/steven.jpg"),
			"text": "conveyer gains + 10 speed for +1 points per food"
		},
		"power2": {
			"img": load("res://images/tyler.jpg"),
			"text": "very low chance for a food to occationally give " + str(global.powerup2_amnt) + " points"
		},
		"power3": {
			"img": load("res://images/hottie.jpg"),
			"text": "+1 spin next round"
		},
		"power4": {
			"img": load("res://images/josh.jpg"),
			"text": "Slower metabolism: 3% gain for calories"
		}
	}
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
