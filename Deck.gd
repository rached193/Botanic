extends Node2D

var player_deck = ["Berbena","Berbena","Berbena"];
const CARD_DRAW_SPEED = 1;



func _ready():
	$RichTextLabel.text = str(player_deck.size())

func draw_card():
	var card_drawn = player_deck.pop_front();
	
	if player_deck.size() == 0:
		$Area2D/CollisionShape2D.disabled = true;
		$Sprite2D.visible = false;
		$RichTextLabel.visible = false;
	
	var card_scene = preload("res://Card.tscn");

	$RichTextLabel.text = str(player_deck.size())
	var new_card = card_scene.instantiate();
	$"../CardManager".add_child(new_card);
	new_card.name = "Card";
	$"../PlayerHand".add_card_to_hand(new_card, CARD_DRAW_SPEED)
