extends Node3D

const diálogo = preload("uid://dvyyx442twn7n")

@onready var area_interactiva: AreaInteractiva = %AreaInteractiva

func _ready() -> void:
	if GameState.global.dia_actual != 1 or "conseguiste_la_info" in GameState.global.hechos_del_dia:
		_desactivar_area()

func _desactivar_area() -> void:
	area_interactiva.set_deferred("monitoring", false)
	area_interactiva.set_deferred("monitorable", false)

func _on_area_interactiva_inicio_interactuar() -> void:
	# TODO: falta el minijuego, por ahora te regalo la info
	DialogueManager.show_dialogue_balloon(diálogo)
	await DialogueManager.dialogue_ended
	_desactivar_area()
	area_interactiva.terminar_interacción()
