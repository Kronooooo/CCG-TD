extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const cb = {
		0:{"title": "Basic TOWER",
			"atk": 20,
			"interval": 1.0,
			"range": 128,
			"canTargetAir": false ,
			"AOE": false,
			"slow":false,
			"dot":false,
			"sprite":"res://Assets/Cards/Units/Basic.png",
			"cost":1
		} ,
		1:{"title": "FLYING TOWER",
			"atk": 20,
			"interval": 1.0,
			"range": 128,
			"canTargetAir": true ,
			"AOE": false,
			"slow":false,
			"dot":false,
			"sprite":"res://Assets/Cards/Units/Flying.png",
			"cost":1
		} ,
		2:{"title": "AOE TOWER",
			"atk": 10,
			"interval": 2.0,
			"range": 192,
			"canTargetAir": false ,
			"AOE": true,
			"slow":false,
			"dot":false,
			"sprite":"res://Assets/Cards/Units/AOE.png",
			"cost":1
		} ,
		3:{"title": "DoT TOWER",
			"atk": 10,
			"interval": 2.0,
			"range": 160,
			"canTargetAir": false ,
			"AOE": false,
			"slow":false,
			"dot":true,
			"sprite":"res://Assets/Cards/Units/DoT.png",
			"cost":1
		} ,
		4:{"title": "SLOW TOWER",
			"atk": 0,
			"interval": 0,
			"range": 256,
			"canTargetAir": true ,
			"AOE": true,
			"slow":true,
			"dot":false,
			"sprite":"res://Assets/Cards/Units/Slow.png",
			"cost":1
		} ,
		
	}
