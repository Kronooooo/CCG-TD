extends Node2D

const NUM_SPRITES = 20

export(Texture) var arrow_texture
var _sprites = []
var startPos
var validPlace = false
var targetFunc
onready var radius = get_parent().cardInfo.get("range")
onready var type = get_parent().cardInfo["type"]
func _ready():
	if type == "tower":
		targetFunc = "towerTarget"
	elif type =="upgrade":
		targetFunc = "upgradeTarget"
		call_deferred("free",$circle)
	elif type =="splash":
		targetFunc = "splashTarget"
	
	if is_instance_valid($circle):
		$circle.radius = radius
		
	for _i in range(NUM_SPRITES):
		var sprite = Sprite.new()
		sprite.texture = arrow_texture
		add_child(sprite)
		_sprites.append(sprite)

	
func draw_path(start_pos, target_pos):
	
	var mid_pos = (target_pos + start_pos) / 2	
	var distance = start_pos.distance_to(target_pos)
	
	mid_pos.y -= 0.4*distance
	
	if target_pos.x < start_pos.x:
		mid_pos.x += 0.4*distance
	else:
		mid_pos.x -= 0.4*distance
		
	var scaling_delta: float = 0.5/float(NUM_SPRITES)
	for i in range(_sprites.size()):
		var s = _sprites[i]
		var path_offset = float(i)/float(NUM_SPRITES-1)
		
		var pos = _quadratic_bezier(start_pos, mid_pos, target_pos, path_offset)
		s.position = pos
		
		var scale_offset = max(1 - (scaling_delta * i), 0.3)
		s.scale = Vector2(scale_offset, scale_offset)
		
		var rot = _quadratic_bezier_angle(start_pos, mid_pos, target_pos, path_offset)
		s.rotation_degrees = rot

	_sprites[NUM_SPRITES-1].scale = Vector2.ONE
	

func _quadratic_bezier(p0: Vector2, p1: Vector2, p2: Vector2, t: float):
	var q0 = p0.linear_interpolate(p1, t)
	var q1 = p1.linear_interpolate(p2, t)
	var r = q0.linear_interpolate(q1, t)
	return r

func _quadratic_bezier_angle(start, control, end, t):
	var tangentX = (2 * (1 - t) * (control.x - start.x)) + (2 * t * (end.x - control.x))
	var tangentY = (2 * (1 - t) * (control.y - start.y)) + (2 * t * (end.y - control.y))
	return (atan2(tangentY, tangentX) * (180 / PI)) + 90

func _process(_delta):
	var mousepos = get_local_mouse_position()
	draw_path(startPos,mousepos)
	$Area2D.position = mousepos
	$towerBox.position = mousepos
	var toreturn = call(targetFunc)
		
	if Input.is_action_just_released("leftclick"):
		if validPlace and targetFunc != "upgradeTarget":
			get_parent().get_parent().get_parent().get_parent().get_node("Level").playCard(get_parent().ID,toreturn)
		elif validPlace and targetFunc == "upgradeTarget":
			toreturn.upgrade(get_parent().cardInfo["stat"],get_parent().cardInfo["amount"])
		queue_free()
	
func towerTarget():
	if len($Area2D.get_overlapping_areas()) ==0:
		modulate = Color("37f647")
		validPlace = true
	else:
		modulate = Color("d52c2c")
		validPlace = false
	return get_local_mouse_position()
	
func splashTarget():
	if get_parent().get_parent().get_parent().get_node("Hand") in $Area2D.get_overlapping_areas():
		modulate = Color("d52c2c")
		validPlace = false
	else:
		modulate = Color("37f647")
		validPlace = true
	return get_local_mouse_position()

func upgradeTarget():
	var areas = $Area2D.get_overlapping_areas()
	if len(areas) > 0:
		for area in areas:
			if area.name == "Tower":
				modulate = Color("37f647")
				validPlace = true
				return area
	else:
		modulate = Color("d52c2c")
		validPlace = false
