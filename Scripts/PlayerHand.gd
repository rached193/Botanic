extends Node2D

class_name PlayerHand

const CARD_WIDTH = 150;
const HAND_Y_POSITION = 700;
const DEFAULT_CARD_MOVE_SPEED = 0.1;

var player_hand: Array[Card] = [];
var center_screen_x

func _ready():
	center_screen_x = get_viewport().size.x / 2;
	


func add_card_to_hand(card: Card, speed: int):
	if card not in player_hand:
		player_hand.insert(0,card);
		update_hand_positions(speed);
	else:
		animate_card_to_position(card, card.starting_position, speed);
	
func update_hand_positions(speed: int):
	for i in range(player_hand.size()):
		print(calculate_card_positions(i),"x", HAND_Y_POSITION)
		var new_position = Vector2(calculate_card_positions(i), HAND_Y_POSITION);
		var card = player_hand[i];
		card.starting_position = new_position;
		animate_card_to_position(card, new_position, speed);
	 
	
func animate_card_to_position(card, new_position, speed):
	var tween = get_tree().create_tween();
	tween.tween_property(card, "position", new_position, speed);	

		
func calculate_card_positions(index):
	var total_width = (player_hand.size() -1) * CARD_WIDTH;
	var x_offset = center_screen_x + index * CARD_WIDTH - total_width / 2;
	return x_offset;

func remove_card_from_hand(card: Card):
	if card in player_hand:
		player_hand.erase(card);
		update_hand_positions(DEFAULT_CARD_MOVE_SPEED);
