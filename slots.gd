extends Node2D

var debounce = true
var end_debounce = false
@onready var slot_images = $Slot_Images
var images = [load("res://images/steven.jpg"),load("res://images/tyler.jpg"),load("res://images/hottie.jpg"),load("res://images/josh.jpg")]
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
				slot.texture = images[randi_range(0,len(images)-1)]
				if i == 9:
					choices.append(slot.texture)
		end_debounce = true
		
func _on_button1_pressed() -> void:
	if end_debounce:
		choose_image(choices[0])

func _on_button2_pressed() -> void:
	if end_debounce:
		choose_image(choices[1])

func _on_button3_pressed() -> void:
	if end_debounce:
		choose_image(choices[2])
	
func choose_image(chosen):
	if chosen == images[0]: 
		pass
	elif chosen == images[1]:
		pass
	elif chosen == images[2]:
		pass
	elif chosen == images[3]:
		pass
