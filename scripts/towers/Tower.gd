extends Area2D

var canShoot = true

var enemies = []
var target

var projectile
var damage = 20 setget , get_damage

onready var Projectile = load("res://scenes/projectiles/Projectile.tscn")
onready var timer = $Timer

func _ready():
	pass
	
func get_damage():
	return damage

func _process(_delta):
	if enemies.size() > 0:
		target = enemies[0]
	else:
		target = null
	
	if target != null and canShoot:
		canShoot = false
		projectile = Projectile.instance()
		call_deferred("add_child",projectile)
		projectile.setTarget(target)
		timer.start()

func _on_Area2D_area_entered(area):
	enemies.append(area.get_parent())

func _on_Area2D_area_exited(area):
	enemies.erase(area.get_parent())
	
func _on_Timer_timeout():
	canShoot = true
