extends PathFollow2D

export var speed = 100

var hp = 100

func _ready():
	pass

func _process(delta):
	offset += delta * speed
	if unit_offset >= 1:
		call_deferred("free")
		get_parent().get_parent().get_parent().hp -= 1

func _on_Area2D_area_entered(area):
	var parent
	print(area.get_groups())
	if area.is_in_group("projectile"):
		parent = area.get_parent()
		hp -= parent.get_damage()
		area.call_deferred("free")
	if hp <= 0:
		parent.enemies.erase(self)
		call_deferred("free")
		
