extends Node2D

class_name Card

signal hovered
signal hovered_off

var card_database_reference;
var card_data;

var starting_position;


func _ready():
	get_parent().connect_card_signals(self);
	card_database_reference = preload("res://Scripts/CardDatabase.gd");

func _on_area_2d_mouse_entered():
	emit_signal("hovered",self)


func _on_area_2d_mouse_exited():
	emit_signal("hovered_off",self)

func init_card_properties(id: String) -> void:
	card_data = card_database_reference.CARDS[id];
	
	
	
