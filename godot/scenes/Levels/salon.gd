extends Node3D


@export var diálogo: DialogueResource = preload("uid://ck20iunbbp7o1")
# @export var diálogo2: DialogueResource = preload("uid://ck20iunbbp7o1")
@onready var puzzle_parar_la_oreja: PuzzlePararLaOreja = %PuzzlePararLaOreja
@onready var puzzle_parar_la_oreja_2: PuzzlePararLaOreja = %PuzzlePararLaOreja2
@onready var area_interactiva: AreaInteractiva = %AreaInteractiva

var intentos: int

func _ready() -> void:
	# TODO desactivar area_interactiva si no es el día y si ya se cumplió la misión de escuchar
	pass

func primer_round() -> void:
	intentos = 0
	DialogueManager.show_dialogue_balloon(diálogo)
	puzzle_parar_la_oreja.fin_del_puzzle.connect(_on_puzzle_parar_la_oreja_fin_del_puzzle)

#func segundo_round() -> void:
	#intentos = 0
	#DialogueManager.show_dialogue_balloon(diálogo)
	#puzzle_parar_la_oreja.fin_del_puzzle.connect(_on_puzzle_parar_la_oreja_fin_del_puzzle)

func _on_puzzle_parar_la_oreja_fin_del_puzzle(éxito: bool) -> void:
	intentos += 1
	if éxito:
		DialogueManager.show_dialogue_balloon(diálogo, "exito")
		puzzle_parar_la_oreja.queue_free()
		puzzle_parar_la_oreja.fin_del_puzzle.disconnect(_on_puzzle_parar_la_oreja_fin_del_puzzle)
		# TODO: sig puzzle
		# segundo_round()
		area_interactiva.terminar_interacción()
	elif intentos == 1:
		DialogueManager.show_dialogue_balloon(diálogo, "reintenta_1")
	elif intentos == 2:
		DialogueManager.show_dialogue_balloon(diálogo, "reintenta_2")
	else:
		DialogueManager.show_dialogue_balloon(diálogo, "fracaso")
		puzzle_parar_la_oreja.queue_free()
		# TODO: arranca persecuta
		area_interactiva.terminar_interacción()


func _on_area_interactiva_inicio_interactuar() -> void:
	primer_round()
