
extends Node

var round 
var bonus_round  #change this into an if elif else statement and a variable called bonus_round so i can detect which one it is 
var SpawnTime
var Points: int
var Goal
var ice_debounce
var base_speed 
var powerup2_debounce 
var powerup2_amnt 
var spin_amnt  
var food_lost: int
var lost_limit: int
var powerup5_debounce 
var leaderboard_stats 
var total_score 
var podium_scores = []
var mouse_location: int
var trash_storage
var trash_stored
var conveyer_additives 
var cash
var items
var perfect_round


var conveyers = {}
#speed is still given to the conveyer, could change in the future
var food_data = {}

func _ready() -> void:
	reset()

func reset():
	round = 1
	bonus_round = [false,false]
	SpawnTime = 10
	Points = 0
	Goal = 100
	ice_debounce = true
	base_speed = 50.0
	powerup2_debounce = false
	powerup2_amnt = 10
	spin_amnt = 1
	food_lost = 0
	lost_limit = 25
	powerup5_debounce = false
	leaderboard_stats = [0,0,0,0,0]
	total_score = 0
	trash_storage = 1
	conveyer_additives = 1
	cash = 0
	items = []
	perfect_round = false
	
	conveyers = {
		"conveyer1":{
			"objects":[],
			"speed": 50.0,
			"direction": 1
		},
		"conveyer2":{
			"objects":[],
			"speed": 50.0,
			"direction": 1
		},
		"conveyer3":{
			"objects":[],
			"speed": 50.0,
			"direction": 1
		}
	}
	
	food_data = {
		"nigiri":{
			"points": 2,
			"speed": 50,
			"image": load("res://images/Sushi/nigiri.png"),
			"name":"nigiri"
		},
		"tempura":{
			"points": 3,
			"speed": 50,
			"image": load("res://images/Sushi/tempura.png"),
			"name":"tempura"
		},
		"californiaroll":{
			"points": 1,
			"speed": 50,
			"image": load("res://images/Sushi/caliroll-export-export.png"),
			"name":"californiaroll"
		},
		"ice":{
			"points": 0,
			"speed": 50,
			"image": load("res://images/Sushi/ice.png"),
			"name": "ice"
		},
		"bomb":{
			"points": 0,
			"speed": 50,
			"image": load("res://images/Sushi/rat.png"),
			"name":"bomb"
		}
	}
