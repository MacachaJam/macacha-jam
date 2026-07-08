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

	var controles: ControlesPantalla = get_tree().get_first_node_in_group("controles_pantalla") as ControlesPantalla
	if controles:
		controles.cambiar_izq_der(true)

	await get_tree().create_timer(2).timeout

	terminar()


func terminar() -> void:
	prints("fin jugar")

	var controles: ControlesPantalla = get_tree().get_first_node_in_group("controles_pantalla") as ControlesPantalla
	if controles:
		controles.cambiar_izq_der(false)

	interfaz.visible = false
	fin_del_minijuego.emit(true)
