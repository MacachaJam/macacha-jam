extends Node2D


func _draw() -> void:
	draw_circle(Vector2.ZERO, 200, Color(0.0, 0.0, 0.0, 0.486))
	draw_arc(Vector2.ZERO, 100, -PI/8, -PI*7/8, 20, Color.RED, 5)
