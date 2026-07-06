extends Node3D

const diálogo = preload("uid://dfrwgissysnsy")

@onready var area_interactiva: AreaInteractiva = %AreaInteractiva

func _ready() -> void:
	if GameState.global.dia_actual != 3 or GameState.global.hechos_del_dia.get("conseguiste_la_info"):
		_desactivar_area()

func _desactivar_area() -> void:
	area_interactiva.set_deferred("monitoring", false)
	area_interactiva.set_deferred("monitorable", false)

func _on_area_interactiva_inicio_interactuar() -> void:
	# TODO: falta el minijuego, por ahora te regalo la info
	GameState.global.hechos_del_dia.conseguiste_la_info = true
	DialogueManager.show_dialogue_balloon(diálogo, "prueba")
	_desactivar_area()
	area_interactiva.terminar_interacción()
