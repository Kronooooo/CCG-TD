extends "res://scripts/enemies/Enemy.gd"

func _ready():
	hp = 200
	speed = 50
	initHpBarValues()
	set_process(true)
