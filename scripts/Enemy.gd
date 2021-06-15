extends PathFollow2D

export var speed = 100

var hp = 5

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
		hp -= 1
		parent = area.get_parent()
		area.call_deferred("free")
	if hp <= 0:
		parent.enemies.erase(self)
		call_deferred("free")
		
