extends Area2D

var canShoot = true

var enemies = []
var target

var projectile
var damage = 0 setget , get_damage
var dotDamage = 10

onready var Projectile = load("res://scenes/projectiles/Projectile.tscn")
onready var timer = $Timer
onready var dotTimer = $DoTTimer

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
		projectile.set_target(target)
		dealDotDamage(target)
		timer.start()
		
func dealDotDamage(enemy):
	for _i in range(5):
		dotTimer.start()
		yield(dotTimer,"timeout")
		enemy.hp -= dotDamage
		enemy.updateHP()

func _on_Area2D_area_entered(area):
	enemies.append(area.get_parent())

func _on_Area2D_area_exited(area):
	enemies.erase(area.get_parent())
	
func _on_Timer_timeout():
	canShoot = true
