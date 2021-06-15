extends PathFollow2D

export var speed = 100

var hp = 5

func _ready():
	print(hp)

func _process(delta):
	offset += delta * speed
	if unit_offset >= 1:
		call_deferred("free")

func _on_Area2D_area_entered(area):
	if area.is_in_group("projectile"):
		hp -= 1
	if hp <= 0:
		area.get_parent().enemies.erase(self)
		call_deferred("free")
		
	area.call_deferred("free")
