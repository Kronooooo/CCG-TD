extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const CardSize = Vector2(125,175)
const CardBase = preload("res://Cards/CardBase.tscn")
var deck = [0,0,0,1,1,1,2,2,2,3,3,3,4,4,4]
var CardOffset = Vector2()
onready var CentreCardOval = get_viewport().size * Vector2(0.5, 1.25)
onready var Hor_rad = get_viewport().size.x*0.28
onready var Ver_rad = get_viewport().size.y*0.45
var angle = 0
var Card_Numb = 0
var NumberCardsHand = 0
var CardSpread = 0.25
var OvalAngleVector = Vector2()
enum{
	InHand
	InPlay
	InMouse
	FocusInHand
	MoveDrawnCardToHand
	ReOrganiseHand
}
# Called when the node enters the scene tree for the first time.
func _ready():
	deck.shuffle()
	for _i in range(0,5):
		drawcard()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func drawcard():
	angle = PI/2 + CardSpread*(float(NumberCardsHand)/2 - NumberCardsHand)
	var new_card = CardBase.instance()
	new_card.ID = deck.pop_front()
#	new_card.rect_position = get_global_mouse_position() 
	OvalAngleVector = Vector2(Hor_rad * cos(angle), - Ver_rad * sin(angle))
	new_card.rect_position = $Deck.position - CardSize/2
	new_card.targetpos = CentreCardOval + OvalAngleVector - CardSize
	new_card.Cardpos = new_card.targetpos
	new_card.startrot = 0
	new_card.targetrot = (90 - rad2deg(angle))/4
	new_card.rect_scale *= CardSize/new_card.rect_size
	new_card.state = MoveDrawnCardToHand
	new_card.Card_Numb = NumberCardsHand
	Card_Numb = 0
	for Card in $Cards.get_children(): # reorganise hand
		angle = PI/2 + CardSpread*(float(NumberCardsHand)/2 - Card_Numb)
		OvalAngleVector = Vector2(Hor_rad * cos(angle), - Ver_rad * sin(angle))
		
		Card.targetpos = CentreCardOval + OvalAngleVector - CardSize
		Card.Cardpos = Card.targetpos # card default pos
		Card.startrot = Card.rect_rotation
		Card.targetrot = (90 - rad2deg(angle))/4
		Card.Card_Numb = Card_Numb
		Card_Numb += 1
		if Card.state == InHand:
			Card.setup = true 
			Card.state = ReOrganiseHand
		elif Card.state == MoveDrawnCardToHand:
			Card.startpos = Card.targetpos - ((Card.targetpos - Card.rect_position)/(1-Card.t))
	$Cards.add_child(new_card)
	angle += 0.25
	NumberCardsHand += 1
#	Card_Numb += 1
func showDeck():
	print("oi")
