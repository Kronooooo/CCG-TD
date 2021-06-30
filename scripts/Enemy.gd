extends PathFollow2D

export var speed = 100 setget set_speed, get_speed

var hp = 100

onready var tween = $Tween
onready var bar = $HP

func set_speed(s):
	speed = s
	
func get_speed():
	return speed

func _ready():
	$HP.set_value(hp)
	$HP.max_value = hp

func _process(delta):
	if hp <= 0:
		get_parent().get_parent().get_parent().spawnedEnemies.erase(self)
		call_deferred("free")
	offset += delta * speed
	if unit_offset >= 1:
		get_parent().get_parent().get_parent().hp -= 1
		get_parent().get_parent().get_parent().spawnedEnemies.erase(self)
		call_deferred("free")

func _on_Area2D_area_entered(area):
	var parent
	if area.is_in_group("projectile"):
		parent = area.get_parent()
		hp -= parent.get_damage()
		area.call_deferred("free")
		updateHP()

func updateHP():
	tween.interpolate_property(bar,"value", bar.value, hp,0.4, tween.TRANS_SINE, tween.EASE_IN_OUT)
	tween.start()
