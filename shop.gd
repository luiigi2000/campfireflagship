extends Node2D

var items = {
	"item1":{
		"image": load("res://images/Sushi/nigiri.png"),
		"text": "idk yet"
	},
	"item2":{
		"image": load("res://images/Sushi/caliroll-export-export.png"),
		"text": "idk yet"
	},
	"item3":{
		"image": load("res://images/Sushi/tempura.png"),
		"text": "idk yet"
	}
}

var selected =  []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reset_shop()



func reset_shop():
	selected.clear()
	for button in $Buttons.get_children():
		var chosen = items.keys()[randi_range(0,len(items.values())-1)]
		var new_item = preload("res://item.tscn").instantiate()
		button.icon = items[chosen]["image"]
		button.text = items[chosen]["text"]
		new_item.icon = items[chosen]["image"]
		new_item.text = items[chosen]["text"]
		new_item.set_meta("item",items.keys().find(chosen))
		selected.push_back(new_item)


func _on_button_pressed() -> void:
	global.items.append(selected[0])
	get_tree().change_scene_to_file("res://main.tscn")


func _on_button_2_pressed() -> void:
	global.items.append(selected[1])


func _on_button_3_pressed() -> void:
	global.items.append(selected[2])
