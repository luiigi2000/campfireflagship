
extends Node

var SpawnTime := 10
var Points := 0
var Goal := 100
var ice_debounce = true
var base_speed := 50.0
var powerup2_debounce = false
var powerup2_amnt = 10
var spin_amnt = 1
var perfect_round = true


var conveyers = {
	"conveyer1":{
		"objects":[],
		"speed": 50.0
	},
	"conveyer2":{
		"objects":[],
		"speed": 50.0   
	},
	"conveyer3":{
		"objects":[],
		"speed": 50.0
	}
}
#speed is still given to the conveyer, could change in the future
var food_data = {
	"nigiri":{
		"points": 2,
		"speed": 50,
		"image": load("res://images/nigiri-sushi-1200.jpg"),
		"name":"nigiri"
	},
	"tobiko":{
		"points": 3,
		"speed": 50,
		"image": load("res://images/tobiko-roll-1200.jpg"),
		"name":"tobiko"
	},
	"californiaroll":{
		"points": 1,
		"speed": 50,
		"image": load("res://images/download (1).jpg"),
		"name":"californiaroll"
	},
	"ice":{
		"points": 0,
		"speed": 50,
		"image": load("res://images/images (1).jpg"),
		"name": "ice"
	},
	"bomb":{
		"points": 0,
		"speed": 50,
		"image": load("res://images/bomb.webp"),
		"name":"bomb"
	}
}


func reset():
	SpawnTime = 10
	Points = 0
	Goal = 100
	ice_debounce = true
	base_speed = 50.0
	powerup2_debounce = false
	powerup2_amnt = 10
	spin_amnt = 1
	perfect_round = true
	
	conveyers = {
		"conveyer1":{
			"objects":[],
			"speed": 50.0
		},
		"conveyer2":{
			"objects":[],
			"speed": 50.0   
		},
		"conveyer3":{
			"objects":[],
			"speed": 50.0
		}
	}
	
	food_data = {
		"nigiri":{
			"points": 2,
			"speed": 50,
			"image": load("res://images/nigiri-sushi-1200.jpg"),
			"name":"nigiri"
		},
		"tobiko":{
			"points": 3,
			"speed": 50,
			"image": load("res://images/tobiko-roll-1200.jpg"),
			"name":"tobiko"
		},
		"californiaroll":{
			"points": 1,
			"speed": 50,
			"image": load("res://images/download (1).jpg"),
			"name":"californiaroll"
		},
		"ice":{
			"points": 0,
			"speed": 50,
			"image": load("res://images/images (1).jpg"),
			"name": "ice"
		},
		"bomb":{
			"points": 0,
			"speed": 50,
			"image": load("res://images/bomb.webp"),
			"name":"bomb"
		}
	}
