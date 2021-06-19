extends Area2D

func _ready():
	pass

func _on_Area2D_area_entered(area):
	var parent = area.get_parent()
	parent.set_speed(parent.get_speed()*0.7)

func _on_Area2D_area_exited(area):
	var parent = area.get_parent()
	parent.set_speed(parent.get_speed()*1/0.7)
