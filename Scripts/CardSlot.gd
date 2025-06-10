extends Node2D

class_name CardSlot

@onready var timer := $Timer
@onready var progress_circle := %ProgressCircle

var current_card: Card = null

func put_card(card: Card):
	current_card = card
	card.global_position = self.global_position  # opcional: alinear
	card.starting_position = self.global_position
	actualizar_estado_boton()
	
func actualizar_estado_boton():
	%StartButton.disabled = is_empty();	
	
func _on_start_button_pressed():
	%StartButton.disabled = true;
	print('hola')
	timer.start(10)
	progress_circle.visible = true
	progress_circle.value = 0

func is_empty() -> bool:
	return current_card == null;
	

func _process(delta):
	if timer.time_left > 0:
		var elapsed = 10.0 - timer.time_left
		progress_circle.value = elapsed
		print(timer.time_left)
		

func _on_timer_timeout():
	print("¡Proceso completado!")
	progress_circle.visible = false
