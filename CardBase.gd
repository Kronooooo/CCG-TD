extends MarginContainer


# Declare member variables here. Examples:
var ID
var startpos = Vector2()
var targetpos = Vector2()
var startrot = 0
var targetrot = 0
var t = 0
var DRAWTIME = 1
var cardInfo
var ORGANISETIME = 0.5
onready var Orig_scale = rect_scale
var targetArrow = preload("res://scenes/cards/targetArrow.tscn")
enum{
	InHand
	InPlay
	InMouse
	FocusInHand
	MoveDrawnCardToHand
	ReOrganiseHand
}
var state = InHand
# Called when the node enters the scene tree for the first time.
func _ready():
	cardInfo = CDB.cb[ID]
	var CardSize = rect_size
	$Border.scale *= CardSize/$Border.texture.get_size()
	$tBorder.scale *= CardSize/$tBorder.texture.get_size()
	$Card.texture = load(cardInfo["sprite"])
	$Card.scale *= CardSize/$Card.texture.get_size()
	$CardBack.scale *= CardSize/$CardBack.texture.get_size()
	$Focus.rect_scale *= CardSize/$Focus.rect_size
	var specialtext = ""
	if cardInfo["type"] =="tower":
		if cardInfo["canTargetAir"]:
			specialtext+= "Targets Air \n"
		if cardInfo["AOE"]:
			specialtext+= "AOE Attacks \n"
		if cardInfo["slow"]:
			specialtext+= "Slows Targets \n"
		if cardInfo["dot"]:
			specialtext+= "Damages Over Time \n"
		specialtext = specialtext.substr(0,len(specialtext)-2)
		$Bars/BottomBar/Health/CenterContainer/Health.text = str(cardInfo["range"])
		$Bars/BottomBar/Attack/CenterContainer/AandR.text = str(cardInfo["atk"],'/',cardInfo["interval"])
	else:
		specialtext = cardInfo["text"]
		
	$Bars/TopBar/Name/CenterContainer/Name.text = cardInfo["title"]
	$Bars/TopBar/Cost/CenterContainer/Cost.text = str(cardInfo["cost"])
	$Bars/SpecialText/Text/CenterContainer/Type.text = specialtext

# Called every frame. 'delta' is the elapsed time since the previous frame.
var setup = true
var startscale = Vector2()
var Cardpos = Vector2()
var ZoomInSize = 2
var ZOOMINTIME = 0.2
var ReorganiseNeighbours = true
var NumberCardsHand = 0
var Card_Numb = 0
var NeighbourCard
var Move_Neightbour_Card_Check = false

func _physics_process(delta):
	match state:
		InHand:
			pass
		InPlay:
			if Input.is_action_just_released("leftclick"):
				$tBorder.visible = false
				
				Reset_Card(Card_Numb)
		InMouse:
			pass
		FocusInHand:
			if setup:
				Setup()
			if t <= 1: # Always be a 1
				rect_position = startpos.linear_interpolate(targetpos, t)
				rect_rotation = startrot * (1-t) + 0*t
				rect_scale = startscale * (1-t) + Orig_scale*2*t
				t += delta/float(ZOOMINTIME)
				if ReorganiseNeighbours:
					ReorganiseNeighbours = false
					NumberCardsHand = $'../../'.NumberCardsHand - 1 # offset for zeroth item
					if Card_Numb - 1 >= 0:
						Move_Neighbour_Card(Card_Numb - 1,true,1) # true is left!
					if Card_Numb - 2 >= 0:
						Move_Neighbour_Card(Card_Numb - 2,true,0.25)
					if Card_Numb + 1 <= NumberCardsHand:
						Move_Neighbour_Card(Card_Numb + 1,false,1)
					if Card_Numb + 2 <= NumberCardsHand:
						Move_Neighbour_Card(Card_Numb + 2,false,0.25)
			else:
				rect_position = targetpos
				rect_rotation = 0
				rect_scale = Orig_scale*ZoomInSize
			if Input.is_action_just_pressed("leftclick"):
				target()
				state = InPlay
		MoveDrawnCardToHand: # animate from the deck to my hand
			if setup:
				Setup()
			if t <= 1: # Always be a 1
				rect_position = startpos.linear_interpolate(targetpos, t)
				rect_rotation = startrot * (1-t) + targetrot*t
				rect_scale.x = Orig_scale.x * abs(2*t - 1)
				if $CardBack.visible:
					if t >= 0.5:
						$CardBack.visible = false
				t += delta/float(DRAWTIME)
			else:
				rect_position = targetpos
				rect_rotation = targetrot
				state = InHand
				t = 0
		ReOrganiseHand:
			if setup:
				Setup()
			if t <= 1: # Always be a 1
				if Move_Neightbour_Card_Check:
					Move_Neightbour_Card_Check = false
				rect_position = startpos.linear_interpolate(targetpos, t)
				rect_rotation = startrot * (1-t) + targetrot*t
				rect_scale = startscale * (1-t) + Orig_scale*t
				t += delta/float(ORGANISETIME)
				if ReorganiseNeighbours == false:
					ReorganiseNeighbours = true
					if Card_Numb - 1 >= 0:
						Reset_Card(Card_Numb - 1) # true is left!
					if Card_Numb - 2 >= 0:
						Reset_Card(Card_Numb - 2)
					if Card_Numb + 1 <= NumberCardsHand:
						Reset_Card(Card_Numb + 1)
					if Card_Numb + 2 <= NumberCardsHand:
						Reset_Card(Card_Numb + 2)
			else:
				rect_position = targetpos
				rect_rotation = targetrot
				rect_scale = Orig_scale
				state = InHand

func Move_Neighbour_Card(Card_Numb,Left,Spreadfactor):
	NeighbourCard = $'../'.get_child(Card_Numb)
	if Left:
		NeighbourCard.targetpos = NeighbourCard.Cardpos - Spreadfactor*Vector2(65,0)
	else:
		NeighbourCard.targetpos = NeighbourCard.Cardpos + Spreadfactor*Vector2(65,0)
	NeighbourCard.setup = true
	NeighbourCard.state = ReOrganiseHand
	NeighbourCard.Move_Neightbour_Card_Check = true
	
func Reset_Card(Card_Numb):
	NeighbourCard = $'../'.get_child(Card_Numb)
#	if NeighbourCard.Move_Neightbour_Card_Check:
#		NeighbourCard.Move_Neightbour_Card_Check = false
	if NeighbourCard.Move_Neightbour_Card_Check == false:
		NeighbourCard = $'../'.get_child(Card_Numb)
		if NeighbourCard.state != FocusInHand:
			NeighbourCard.state = ReOrganiseHand
			NeighbourCard.targetpos = NeighbourCard.Cardpos
			NeighbourCard.setup = true

func Setup():
	startpos = rect_position
	startrot = rect_rotation
	startscale = rect_scale
	t = 0
	setup = false

func _on_Focus_mouse_entered():
	match state:
		InHand, ReOrganiseHand:
			setup = true
			targetpos = Cardpos
			targetpos.y = get_viewport().size.y - $'../../'.CardSize.y*ZoomInSize
			state = FocusInHand


func _on_Focus_mouse_exited():
	match state:
		FocusInHand:
			setup = true
			targetpos = Cardpos
			state = ReOrganiseHand

func target():
	var arrow = targetArrow.instance()
	arrow.startPos = get_local_mouse_position() 
	add_child(arrow)
	$tBorder.visible = true
func _on_Focus_pressed():
	pass


func _on_Focus_gui_input(event):
	if event is InputEventMouseButton and event.doubleclick:
		if state == FocusInHand and cardInfo["type"] == "effect":
			CDB.call(cardInfo["funcName"])
