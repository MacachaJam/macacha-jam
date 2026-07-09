extends Node3D

signal llego_cliente

const diálogo = preload("uid://dvyyx442twn7n")
const civil = preload("uid://ei55uh7seli8")

@onready var area_interactiva: AreaInteractiva = %AreaInteractiva
@onready var player_minigame: AnimatedSprite3D = %PlayerMinigame
@onready var spawn_clientes: Node3D = %SpawnClientes
@onready var clientes: Node3D = %Clientes

var errores: int

func _ready() -> void:
	if GameState.global.dia_actual != 1 or GameState.global.hechos_del_dia.get("conseguiste_la_info"):
		_desactivar_area()

func _desactivar_area() -> void:
	area_interactiva.set_deferred("monitoring", false)
	area_interactiva.set_deferred("monitorable", false)

func _obtener_un_spawn_clientes() -> Marker3D:
	return spawn_clientes.get_children().pick_random() as Marker3D

func spawn_cliente() -> void:
	var n := civil.instantiate() as Civil
	n.personaje = Civil.Personaje.MUJER_1
	clientes.add_child(n)
	n.global_position = _obtener_un_spawn_clientes().global_position
	n.llegó.connect(_on_cliente_llegó)
	var player: Node3D = get_tree().get_first_node_in_group("player")
	n.ir_a(player.global_position)

func _on_cliente_llegó() -> void:
	llego_cliente.emit()

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
		area_interactiva.terminar_interacción(true)
