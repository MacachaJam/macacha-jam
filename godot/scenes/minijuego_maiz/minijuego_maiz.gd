class_name MinijuegoMaiz
extends Node

signal fin_del_minijuego(éxito: bool)

@export var interfaz: InterfazMaiz

var _puntaje: float

func iniciar() -> void:
	interfaz.visible = true
	_puntaje = 0
	# TODO jugar
	prints("jugar")
	await get_tree().create_timer(2).timeout
	prints("fin jugar")
	interfaz.visible = false
	fin_del_minijuego.emit(true)
