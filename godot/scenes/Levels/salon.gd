extends Node3D


const diálogo: DialogueResource = preload("uid://dxbq8ut0rgvof")

@onready var puzzle_parar_la_oreja: PuzzlePararLaOreja = %PuzzlePararLaOreja
@onready var puzzle_parar_la_oreja_2: PuzzlePararLaOreja = %PuzzlePararLaOreja2
@onready var area_interactiva: AreaInteractiva = %AreaInteractiva
@onready var npcs: Node3D = %NPCS
@onready var moro: AnimatedSprite3D = %Moro
@onready var serna: AnimatedSprite3D = %Serna

var ronda: int
var intentos: int

func _ready() -> void:
	npcs.visible = GameState.global.dia_actual == 2
	if GameState.global.dia_actual != 2 or GameState.global.hechos_del_dia.get("conseguiste_la_info"):
		_desactivar_area()
	else:
		DialogueManager.got_dialogue.connect(_on_got_dialogue)

func _desactivar_area() -> void:
	area_interactiva.set_deferred("monitoring", false)
	area_interactiva.set_deferred("monitorable", false)

func _on_got_dialogue(line: DialogueLine) -> void:
	if line.character == "Juana Moro":
		moro.play("hablando")
		serna.play("idle")
	elif  line.character == "José de la Serna":
		moro.play("idle")
		serna.play("hablando")

func habla_jose() -> void:
	moro.play("idle")
	serna.play("hablando")


func _on_area_interactiva_inicio_interactuar() -> void:
	ronda = 1
	intentos = 0

	var jugadora: Jugadora = get_tree().get_first_node_in_group("player") as Jugadora
	if jugadora:
		jugadora.cambiar_abanicar(true)

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
			terminar()
	elif intentos == 1:
		DialogueManager.show_dialogue_balloon(diálogo, "reintenta_1")
	elif intentos == 2:
		DialogueManager.show_dialogue_balloon(diálogo, "reintenta_2")
	else:
		DialogueManager.show_dialogue_balloon(diálogo, "fracaso")
		await DialogueManager.dialogue_ended
		terminar()

func terminar() -> void:
	moro.play("hablando")
	serna.play("hablando")
	var jugadora: Jugadora = get_tree().get_first_node_in_group("player") as Jugadora
	if jugadora:
		jugadora.cambiar_abanicar(false)
	area_interactiva.terminar_interacción(true)
