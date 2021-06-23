extends TextureButton


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var Decksize = INF

# Called when the node enters the scene tree for the first time.
func _ready():
	rect_scale *= $'../../'.CardSize/rect_size



func _gui_input(_event):
	if Input.is_action_just_released("leftclick"):
		if len($'../../'.deck) > 0:
			$'../../'.showDeck()
			if Decksize == 0:
				disabled = true
