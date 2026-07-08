extends Node3D

const diálogo = preload("uid://dfrwgissysnsy")

@onready var minijuego_maiz: MinijuegoMaiz = %MinijuegoMaiz
@onready var area_interactiva: AreaInteractiva = %AreaInteractiva
@onready var player_minigame: AnimatedSprite3D = %PlayerMinigame

var intentos: int

func _ready() -> void:
	if GameState.global.dia_actual != 3 or GameState.global.hechos_del_dia.get("conseguiste_la_info"):
		_desactivar_area()

func _desactivar_area() -> void:
	area_interactiva.set_deferred("monitoring", false)
	area_interactiva.set_deferred("monitorable", false)

func _on_area_interactiva_inicio_interactuar() -> void:
	var player: Node3D = get_tree().get_first_node_in_group("player")
	player.visible = false
	player_minigame.visible = true
	intentos = 0
	DialogueManager.show_dialogue_balloon(diálogo)
	minijuego_maiz.fin_del_minijuego.connect(_on_minijuego_maiz_fin_del_minijuego)

func _on_minijuego_maiz_fin_del_minijuego(éxito: bool) -> void:
	intentos += 1
	if éxito:
		DialogueManager.show_dialogue_balloon(diálogo, "exito")
		await DialogueManager.dialogue_ended
		retornar_del_minijuego()
	elif intentos == 1:
		DialogueManager.show_dialogue_balloon(diálogo, "reintenta_1")
	elif intentos == 2:
		DialogueManager.show_dialogue_balloon(diálogo, "reintenta_2")
	else:
		DialogueManager.show_dialogue_balloon(diálogo, "fracaso")
		await DialogueManager.dialogue_ended
		retornar_del_minijuego()

func retornar_del_minijuego() -> void:
	var player: Node3D = get_tree().get_first_node_in_group("player")
	player.visible = true
	player_minigame.visible = false
	_desactivar_area()
	area_interactiva.terminar_interacción()
