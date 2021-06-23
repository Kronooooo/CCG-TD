extends Node

onready var timer = $Timer

var level
var hp = 15

var levels = [preload("res://scenes/levels/Level1.tscn"),preload("res://scenes/levels/Level2.tscn"), preload("res://scenes/levels/Level3.tscn")]
var enemies = [preload("res://scenes/enemies/Enemy.tscn"),preload("res://scenes/enemies/AirEnemy.tscn")]
var paths = []

var spawnedEnemies = {}
var numEnemies = 10
var numBasic = 0
var numAir = 0

onready var tower = load("res://scenes/towers/Tower.tscn")

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
	
	for i in range(numEnemies):
		randomize()
		enemies.shuffle()
		var enemy = enemies[0].instance()
		var path = paths[i % paths.size()]
		spawnedEnemies[enemy] = path
		if "Air" in enemy.get_name():
			numAir += 1
		else:
			numBasic += 1

func spawnEnemies():
	for enemy in spawnedEnemies.keys():
		var path = spawnedEnemies[enemy]
		timer.start()
		yield(timer,"timeout")
		level.get_node(path.get_name()).call_deferred("add_child",enemy)
	
func playCard(id,pos):
	var type = CDB.CB[id]["type"]
	if type == "tower":
		var x = tower.instance()
		x.position = pos
		call_deferred("add_child",x)
		x.initTower(id)

func _on_Button_pressed():
	spawnEnemies()
	$Button.disabled = true
