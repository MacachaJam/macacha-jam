class_name ActivarPorAtuendo
extends Node

@export var area: Area3D
@export var atuendo: Jugadora.Atuendos

func _ready() -> void:
	_on_gamestate_cambió_atuendo()
	GameState.global.cambió_atuendo.connect(_on_gamestate_cambió_atuendo)

func _on_gamestate_cambió_atuendo() -> void:
	var activar := atuendo == GameState.global.atuendo_actual
	area.set_deferred("monitoring", activar)
	area.set_deferred("monitorable", activar)
