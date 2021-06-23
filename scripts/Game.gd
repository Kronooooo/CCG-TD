extends Node

onready var timer = $Timer

var level
var hp = 15

var tower = preload("res://scenes/towers/Tower.tscn")
var levels = [preload("res://scenes/levels/Level1.tscn"),preload("res://scenes/levels/Level2.tscn"), preload("res://scenes/levels/Level3.tscn")]
var enemies = [preload("res://scenes/enemies/Enemy.tscn"),preload("res://scenes/enemies/AirEnemy.tscn")]
var paths = []

func _ready():
	createLevel()

func _process(_delta):
	$Label2.set_text(str(hp))
	if hp <= 0:
		print("you lost lmao")
		get_tree().quit()

func createLevel():
	randomize()
	levels.shuffle()
	level = levels[0].instance()
	call_deferred("add_child",level)
	for child in level.get_children():
		if "Path" in child.get_name():
			paths.append(child)
	
	for i in range(1):
		randomize()
		enemies.shuffle()
		timer.start()
		yield(timer,"timeout")
		var enemy = enemies[0].instance()
		var path = paths[i % paths.size()]
		level.get_node(path.get_name()).call_deferred("add_child",enemy)
		
func x(id,pos):
	var type = CDB.CB[id]["type"]
	if type == "tower":
		var x = tower.instance(id)
		x.pos = pos
		call_deferred("add_child",x)
