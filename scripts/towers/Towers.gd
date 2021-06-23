extends Area2D

var damage setget , get_damage
var canShoot
var enemies = []
var slow = false
var dot = false
var interval
var slowAmount = 0.7

var Projectile
var damageFunction

onready var timer = $Timer

func _ready():
	pass
	
func _process(_delta):
	call(damageFunction)

func get_damage():
	return damage
	
func initTower(id):
	var dict = CDB.CB[id]
	damage = dict["atk"]
	interval = dict["interval"]
	timer.set_wait_time(interval)
	$Area2D/CollisionShape2D.shape.set_radius(dict["range"])
	$Sprite.set_texture(load(dict["sprite"]))
	
	if dict["canTargetAir"]:
		$Area2D.set_collision_mask_bit(2,true)
		Projectile = load("res://scenes/projectiles/AirProjectile.tscn")
	else:
		Projectile = load("res://scenes/projectiles/Projectile.tscn")
		$Area2D.set_collision_mask_bit(1,true)
		
	if dict["AOE"]:
		damageFunction = "damageAoE"
		canShoot = true
	else:
		damageFunction = "damageSingle"
		canShoot = true
		
	slow = dict["slow"]
	dot = dict["dot"]

func damageAoE():
	var projectile
	if canShoot:
		if enemies.size() != 0:
			canShoot = false
			for target in enemies:
				projectile = Projectile.instance()
				call_deferred("add_child",projectile)
				projectile.set_target(target)
			timer.start()
			
func damageSingle():
	var projectile
	var target
	if enemies.size() > 0:
		target = enemies[0]
	else:
		target = null
	
	if target != null and canShoot:
		canShoot = false
		projectile = Projectile.instance()
		call_deferred("add_child",projectile)
		projectile.set_target(target)
		timer.start()
		if dot:
			damageDoT(target)

func damageDoT(enemy):
	for _i in range(5):
		yield(get_tree().create_timer(0.5),"timeout")
		enemy.hp -= damage
		enemy.updateHP()

func _on_Area2D_area_entered(area):
	if slow:
		var parent = area.get_parent()
		parent.set_speed(parent.get_speed()*slowAmount)
	else:
		enemies.append(area.get_parent())

func _on_Area2D_area_exited(area):
	if slow:
		var parent = area.get_parent()
		parent.set_speed(parent.get_speed()*(1/slowAmount))
	else:
		enemies.append(area.get_parent())

func _on_Timer_timeout():
	canShoot = true
	
func upgrade(stat,amount):
	if stat == "atk":
		damage += amount
	elif stat == "spd":
		interval -= amount
	elif stat == "slow":
		slowAmount += amount
