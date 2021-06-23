extends Area2D

var target setget set_target
var speed = 400
var direction

func _ready():
	pass
	
func _process(delta):
	if is_instance_valid(target):
		direction = (target.global_position - global_position).normalized()
		position += direction * speed * delta
	else:
		call_deferred("free")
		
func set_target(t):
	target = t
