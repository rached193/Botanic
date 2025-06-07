extends Control

@onready var name_label = %NameLabel
@onready var description_text = %DescriptionText
#@onready var icon_container = %IconContainer

func show_card_detail(card_data: Dictionary):
	visible = true
	print(card_data)
	name_label.text = card_data.get("name", "???")
	description_text.text = card_data.get("description", "")
	
	## Limpiar iconos anteriores
	#for child in icon_container.get_children():
		#child.queue_free()
#
	#for icon_path in card_data.get("icons", []):
		#var icon = TextureRect.new()
		#icon.texture = load(icon_path)
		#icon_container.add_child(icon)

func _on_close_button_pressed():
	visible = false
