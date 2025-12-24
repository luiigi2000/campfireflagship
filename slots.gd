extends Node2D

var debounce = true
var end_debounce = false
@onready var slot_images = $Slot_Images
var powerups = {
	"power1": {
		"img": load("res://images/steven.jpg"),
		"text": "conveyer gains + 10 speed for +1 points per food"
	},
	"power2": {
		"img": load("res://images/tyler.jpg"),
		"text": "higher chance for buffs"
	},
	"power3": {
		"img": load("res://images/hottie.jpg"),
		"text": "higher chance for debuffs with faster conveyer speed"
	},
	"power4": {
		"img": load("res://images/josh.jpg"),
		"text": "Slower motabalism: 10% for calorie gain"
	}
}

var choices = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
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
		for food in global.food_data.values():
			print(food["points"])
			
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://main.tscn")
