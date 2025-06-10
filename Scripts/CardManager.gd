extends Node2D

const COLISSION_MASK_CARD = 1
const COLISSION_MASK_CARD_SLOT = 2
const DEFAULT_CARD_MOVE_SPEED = 0.1;

var screen_size: Vector2;
var card_being_dragged: Card;
var is_hovering_on_card: bool;
var player_hand_reference: PlayerHand;
var card_detail_ui;

func _ready() -> void:
	screen_size = get_viewport_rect().size
	player_hand_reference = $"../PlayerHand";
	card_detail_ui = $"../CardDetailUi/Panel"
	$"../InputManager".connect("left_mouse_button_released", on_left_click_released)

func _process(_delta: float) -> void:
	if card_being_dragged:
		var mouse_pos = get_global_mouse_position()
		card_being_dragged.position = Vector2(
			clamp(mouse_pos.x,0, screen_size.x), 
			clamp(mouse_pos.y,0,screen_size.y)
		)

func start_drag(card: Card) -> void:
	card_detail_ui.show_card_detail(card.card_data);
	card_being_dragged = card;
	
func finish_drag():
	var card_slot_found: CardSlot = raycast_check_for_card_slot()
	if card_slot_found and card_slot_found.is_empty():
		card_slot_found.put_card(card_being_dragged);
		player_hand_reference.remove_card_from_hand(card_being_dragged);
		#card_being_dragged.position = card_slot_found.position;
		#card_being_dragged.get_node("Area2D/CollisionShape2D").disabled = true;
	else:
		player_hand_reference.add_card_to_hand(card_being_dragged, DEFAULT_CARD_MOVE_SPEED);
	card_being_dragged = null
	
func connect_card_signals(card):
	card.connect("hovered",on_hovered_over_card)
	card.connect("hovered_off",on_hovered_off_card)
	
func on_left_click_released():
	if card_being_dragged: 
		finish_drag()
	
func on_hovered_over_card(card):
	if !is_hovering_on_card:
		is_hovering_on_card = true
		highlight_card(card,true)
	
func on_hovered_off_card(card): 
	var new_card_hovered = raycast_check_for_card() 
	highlight_card(card, false)
	if !new_card_hovered:
		is_hovering_on_card = false
	elif card != new_card_hovered:
		highlight_card(new_card_hovered, true)
	

func highlight_card(card, hovered):
	if hovered:
		card.scale = Vector2(1.05,1.05)
		card.z_index = 2
	else:
		card.scale = Vector2(1,1)
		card.z_index = 1



func raycast_check_for_card() -> Card:
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLISSION_MASK_CARD
	var result = space_state.intersect_point(parameters)
	if result.size() > 0 :
		return get_card_with_higest_z_index(result)
	else:
		return null
		
func raycast_check_for_card_slot() -> CardSlot:
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLISSION_MASK_CARD_SLOT
	var result = space_state.intersect_point(parameters)
	if result.size() > 0 :
		return result[0].collider.get_parent()
	else:
		return null
		

func get_card_with_higest_z_index(cards: Array[Dictionary]):
	var highest_z_card = cards[0].collider.get_parent()
	var highest_z_index = highest_z_card.z_index
	
	for i in range(1, cards.size()):
		var current_card = cards[i].collider.get_parent()
		if current_card.z_index > highest_z_index:
			highest_z_card = current_card
			highest_z_index = current_card.z_index
	return highest_z_card
