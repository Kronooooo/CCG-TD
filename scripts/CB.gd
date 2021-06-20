extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const CardBase = {
		0:{"title": "Test Card TOWER",
			"atk": 20,
			"interval": 1.0,
			"range": 128,
			"canTargetAir": false ,
			"AOE": false,
			"slow":false,
			"dot":false,
			"sprite":"res://sprites/towers/temp-tower.png",
		} ,
		1:{"title": "Test Card FLYING TOWER",
			"atk": 20,
			"interval": 1.0,
			"range": 128,
			"canTargetAir": true ,
			"AOE": false,
			"slow":false,
			"dot":false,
			"sprite":"res://sprites/towers/temp-air-tower.png",
		} ,
		2:{"title": "Test Card AOE TOWER",
			"atk": 10,
			"interval": 2.0,
			"range": 192,
			"canTargetAir": false ,
			"AOE": true,
			"slow":false,
			"dot":false,
			"sprite":"res://sprites/towers/temp-aoe-tower.png",
		} ,
		3:{"title": "Test Card DoT TOWER",
			"atk": 10,
			"interval": 2.0,
			"range": 160,
			"canTargetAir": false ,
			"AOE": false,
			"slow":false,
			"dot":true,
			"sprite":"res://sprites/towers/temp-dot-tower.png",
		} ,
		4:{"title": "Test Card SLOW TOWER",
			"atk": 0,
			"interval": 0,
			"range": 256,
			"canTargetAir": true ,
			"AOE": true,
			"slow":true,
			"dot":false,
			"sprite":"res://sprites/towers/temp-slow-tower.png",
		} ,
		
	}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
