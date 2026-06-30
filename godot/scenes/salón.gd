extends Node3D

@export var diálogo: DialogueResource = preload("uid://ck20iunbbp7o1")
@onready var puzzle_parar_la_oreja: PuzzlePararLaOreja = %PuzzlePararLaOreja

var intentos: int

func _ready() -> void:
	intentos = 0
	DialogueManager.show_dialogue_balloon(diálogo)
	puzzle_parar_la_oreja.fin_del_puzzle.connect(_on_puzzle_parar_la_oreja_fin_del_puzzle)

func _on_puzzle_parar_la_oreja_fin_del_puzzle(éxito: bool) -> void:
	intentos += 1
	if éxito:
		DialogueManager.show_dialogue_balloon(diálogo, "exito")
		puzzle_parar_la_oreja.queue_free()
	elif intentos == 1:
		DialogueManager.show_dialogue_balloon(diálogo, "reintenta_1")
	elif intentos == 2:
		DialogueManager.show_dialogue_balloon(diálogo, "reintenta_2")
	else:
		DialogueManager.show_dialogue_balloon(diálogo, "fracaso")
		puzzle_parar_la_oreja.queue_free()
