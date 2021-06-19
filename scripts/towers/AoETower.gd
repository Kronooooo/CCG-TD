extends Area2D

var canShoot = true

var enemies = []

var projectile
var damage = 10 setget , get_damage

onready var Projectile = load("res://scenes/projectiles/Projectile.tscn")
onready var timer = $Timer

func _ready():
	pass
	
func get_damage():
	return damage

func _process(_delta):
	if canShoot:
		if enemies.size() != 0:
			canShoot = false
			for target in enemies:
				projectile = Projectile.instance()
				call_deferred("add_child",projectile)
				projectile.set_target(target)
			timer.start()

func _on_Area2D_area_entered(area):
	enemies.append(area.get_parent())

func _on_Area2D_area_exited(area):
	enemies.erase(area.get_parent())
	
func _on_Timer_timeout():
	canShoot = true
