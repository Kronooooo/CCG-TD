extends "res://scripts/enemies/Enemy.gd"


func _ready():
	hp = 50
	speed = 200
	initHpBarValues()
	set_process(true)
