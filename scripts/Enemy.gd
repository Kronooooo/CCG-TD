extends PathFollow2D

export var speed = 100 setget set_speed, get_speed

var hp = 100

func set_speed(s):
	speed = s
	
func get_speed():
	return speed

func _ready():
	pass

func _process(delta):
	offset += delta * speed
	if unit_offset >= 1:
		call_deferred("free")
		get_parent().get_parent().get_parent().hp -= 1

func _on_Area2D_area_entered(area):
	var parent
	if area.is_in_group("projectile"):
		parent = area.get_parent()
		hp -= parent.get_damage()
		area.call_deferred("free")
	if hp <= 0:
		parent.enemies.erase(self)
		call_deferred("free")
		
