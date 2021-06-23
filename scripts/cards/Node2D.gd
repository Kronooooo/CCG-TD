extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var radius
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
func _draw():
	draw_circle(get_local_mouse_position(),radius,Color("843a9ad3"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	update()
