extends Node

onready var timer = $Timer

var level
var wave = 1
var hp = 15
var waveCompleted = false

var levels = [preload("res://scenes/levels/Level1.tscn"),preload("res://scenes/levels/Level2.tscn"), preload("res://scenes/levels/Level3.tscn")]
var enemies = [preload("res://scenes/enemies/Enemy.tscn"),preload("res://scenes/enemies/AirEnemy.tscn")]
var paths = []

var spawnedEnemies = {}
var numEnemies = 10
var numBasic = 0
var numAir = 0

onready var tower = load("res://scenes/towers/Tower.tscn")
onready var Vbox = $CanvasLayer/ColorRect/VBoxContainer
onready var HboxBasic = $CanvasLayer/ColorRect/VBoxContainer/HBoxContainer
onready var HboxAir = $CanvasLayer/ColorRect/VBoxContainer/HBoxContainer2

func _ready():
	createLevel()
	createEnemies()

func _process(_delta):
	$Label2.set_text(str(hp))
	if hp <= 0:
		print("you lost lmao")
		get_tree().quit()

	if spawnedEnemies.empty() and waveCompleted == false:
		waveCompleted = true
		wave += 1
		if wave % 5 == 0:
			switchLevels()
			waveCompleted = false
		else:
			createEnemies()
			waveCompleted = false

func createLevel():
	randomize()
	levels.shuffle()
	level = levels[0].instance()
	call_deferred("add_child",level)
	for child in level.get_children():
		if "Path" in child.get_name():
			paths.append(child)

func createEnemies():
	$Button.disabled = false
	numAir = 0
	numBasic = 0
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
		
	updateWavePreview()

func switchLevels():
	level.call_deferred("free")
	paths.clear()
	spawnedEnemies.clear()
	clearTowers()
	createLevel()
	createEnemies()

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
		
func updateWavePreview():
	var size = 0
	
	if numBasic > 0:
		size += 64
		HboxBasic.visible = true
		HboxBasic.get_node("Label").set_text(str(numBasic))
	if numAir > 0:
		size += 64
		HboxAir.visible = true
		HboxAir.get_node("Label").set_text(str(numAir))

	Vbox.rect_size.y = size
	Vbox.get_parent().rect_size.y = size
		
func closeWavePreview():
	Vbox.rect_size.y = 0
	Vbox.get_parent().rect_size.y = 0
	HboxBasic.visible = false
	HboxAir.visible = false
	
func clearTowers():
	for x in get_children():
		if "tower" in x.get_name().to_lower():
			x.call_deferred("free")

func _on_Button_pressed():
	closeWavePreview()
	spawnEnemies()
	$Button.disabled = true
