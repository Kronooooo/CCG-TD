extends Area2D

var target
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
		
func setTarget(t):
	target = t
