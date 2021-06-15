extends PathFollow2D

export var speed = 100

func _process(delta):
	offset += delta * speed
