class_name InterfazSilabeador
extends Node2D

signal llegó(índice_sílaba: int)
@export var cantidad_de_sílabas: int

func _draw() -> void:
	draw_circle(Vector2.ZERO, 200, Color(0.0, 0.0, 0.0, 0.486))
	draw_arc(Vector2.ZERO, 100, -PI/8, -PI*7/8, 20, Color.RED, 5)

func iniciar() -> void:
	for i in range(cantidad_de_sílabas):
		await get_tree().create_timer(0.5).timeout
		llegó.emit(i)
		
