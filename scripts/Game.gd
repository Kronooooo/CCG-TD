extends Node

onready var Enemy = load("res://scenes/Enemy.tscn")
onready var timer = $Timer

var level
var hp = 15

var levels = [preload("res://scenes/Level1.tscn"),preload("res://scenes/Level2.tscn"), preload("res://scenes/Level3.tscn")]
var paths = []

func _ready():
	createLevel()

func _process(_delta):
	if hp <= 0:
		print("you lost lmao")
		get_tree().quit()

func createLevel():
	randomize()
	#levels.shuffle()
	level = levels[1].instance()
	call_deferred("add_child",level)
	for child in level.get_children():
		if "Path" in child.get_name():
			paths.append(child)
	
	for i in range(30):
		timer.start()
		yield(timer,"timeout")
		var enemy = Enemy.instance()
		var path = paths[i % paths.size()]
		level.get_node(path.get_name()).call_deferred("add_child",enemy)
