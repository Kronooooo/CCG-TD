extends Area2D

var canShoot = true

var enemies = []
var target

var projectile
onready var Projectile = load("res://scenes/Projectile.tscn")
onready var timer = $Timer

const RADIUS = 128

func _ready():
	pass

func _process(_delta):
	if enemies.size() > 0:
		target = enemies[0]
	else:
		target = null
	
	if target != null and canShoot:
		print("got")
		canShoot = false
		projectile = Projectile.instance()
		call_deferred("add_child",projectile)
		projectile.setTarget(target)
		timer.start()

func _on_Area2D_area_entered(area):
	enemies.append(area.get_parent())

func _on_Timer_timeout():
	canShoot = true
