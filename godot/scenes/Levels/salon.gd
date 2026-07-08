extends Node3D


const diálogo: DialogueResource = preload("uid://dxbq8ut0rgvof")

@onready var puzzle_parar_la_oreja: PuzzlePararLaOreja = %PuzzlePararLaOreja
@onready var puzzle_parar_la_oreja_2: PuzzlePararLaOreja = %PuzzlePararLaOreja2
@onready var area_interactiva: AreaInteractiva = %AreaInteractiva
@onready var npcs: Node3D = %NPCS

var ronda: int
var intentos: int

func _ready() -> void:
	npcs.visible = GameState.global.dia_actual == 2
	if GameState.global.dia_actual != 2 or GameState.global.hechos_del_dia.get("conseguiste_la_info"):
		_desactivar_area()

func _desactivar_area() -> void:
	area_interactiva.set_deferred("monitoring", false)
	area_interactiva.set_deferred("monitorable", false)

func iniciar() -> void:
	ronda = 1
	intentos = 0
	DialogueManager.show_dialogue_balloon(diálogo)
	puzzle_parar_la_oreja.fin_del_puzzle.connect(_on_puzzle_parar_la_oreja_fin_del_puzzle)
	puzzle_parar_la_oreja_2.fin_del_puzzle.connect(_on_puzzle_parar_la_oreja_fin_del_puzzle)

func _on_puzzle_parar_la_oreja_fin_del_puzzle(éxito: bool) -> void:
	intentos += 1
	if éxito:
		if ronda == 1:
			ronda += 1
			# Reiniciar intentos para el segundo round.
			intentos = 0
			DialogueManager.show_dialogue_balloon(diálogo, "segundo_round")
		else:
			DialogueManager.show_dialogue_balloon(diálogo, "exito")
			await DialogueManager.dialogue_ended
			area_interactiva.terminar_interacción(true)
	elif intentos == 1:
		DialogueManager.show_dialogue_balloon(diálogo, "reintenta_1")
	elif intentos == 2:
		DialogueManager.show_dialogue_balloon(diálogo, "reintenta_2")
	else:
		DialogueManager.show_dialogue_balloon(diálogo, "fracaso")
		await DialogueManager.dialogue_ended
		area_interactiva.terminar_interacción(true)


func _on_area_interactiva_inicio_interactuar() -> void:
	iniciar()
