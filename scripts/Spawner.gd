extends Node

onready var Enemy = load("res://scenes/Enemy.tscn")
onready var Test = load("res://scenes/Test.tscn")
onready var timer = $Timer

var level
var hp = 15

func _ready():
	level = Test.instance()
	call_deferred("add_child",level)
	for _i in range(30):
		timer.start()
		yield(timer,"timeout")
		var enemy = Enemy.instance()
		level.get_node("Path2D").call_deferred("add_child",enemy)

func _process(_delta):
	if hp <= 0:
		print("fin")
		get_tree().quit()
