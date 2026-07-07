class_name ActivarPorAtuendo
extends Node

@export var nodo: Node3D
@export var atuendo: Jugadora.Atuendos
@export var negado: bool

func _ready() -> void:
	_on_gamestate_cambió_atuendo()
	GameState.global.cambió_atuendo.connect(_on_gamestate_cambió_atuendo)

func _on_gamestate_cambió_atuendo() -> void:
	var activar := atuendo == GameState.global.atuendo_actual
	if negado:
		activar = not activar
	if nodo is Area3D:
		var area := nodo as Area3D
		area.set_deferred("monitoring", activar)
		area.set_deferred("monitorable", activar)
	elif nodo is CollisionShape3D:
		var coli := nodo as CollisionShape3D
		coli.disabled = not activar
	else:
		push_warning("no sé como activar %s" % nodo)
