extends Node3D

const diálogo = preload("uid://dvyyx442twn7n")

@onready var area_interactiva: AreaInteractiva = %AreaInteractiva
@onready var player_minigame: AnimatedSprite3D = %PlayerMinigame

func _ready() -> void:
	if GameState.global.dia_actual != 1 or GameState.global.hechos_del_dia.get("conseguiste_la_info"):
		_desactivar_area()

func _desactivar_area() -> void:
	area_interactiva.set_deferred("monitoring", false)
	area_interactiva.set_deferred("monitorable", false)

func _on_area_interactiva_inicio_interactuar() -> void:
	if GameState.global.atuendo_actual != Jugadora.Atuendos.VENDEDORA:
		DialogueManager.show_dialogue_balloon(diálogo, "atuendo_incorrecto")
		await DialogueManager.dialogue_ended
		area_interactiva.terminar_interacción()
	else:
		var player: Node3D = get_tree().get_first_node_in_group("player")
		player.visible = false
		player_minigame.visible = true
		DialogueManager.show_dialogue_balloon(diálogo)
		await DialogueManager.dialogue_ended
		player.visible = true
		player_minigame.visible = false
		_desactivar_area()
		area_interactiva.terminar_interacción()
