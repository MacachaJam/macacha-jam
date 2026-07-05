class_name EfectoSquashStretch
extends Node

@export var nodos: Array[Node3D]
@export_range(0, 2000, 1, "or_more", "or_less") var minimum_spring: float = 500
@export_range(0, 2000, 1, "or_more", "or_less") var maximum_spring: float = 700

@export_range(0, 20, 1, "or_more", "or_less") var minimum_damp: float = 2
@export_range(0, 20, 1, "or_more", "or_less") var maximum_damp: float = 7

@export_range(0, 100, 1, "or_more", "or_less") var minimum_velocity: float = 5
@export_range(0, 100, 1, "or_more", "or_less") var maximum_velocity: float = 25

@export_range(0, 1, .05, "or_more", "or_less") var factor_scale: float = 0.15

# TODO: hacer que damped oscillator sea una tool
# @export_tool_button("probar") var botón_probar: Callable = probar

func squash_stretch() -> void:
	for nodo: Node3D in nodos:
		var spring := minimum_spring + (maximum_spring - minimum_spring) * randf()
		var damp := minimum_damp + (maximum_damp - minimum_damp) * randf()
		var velocity := minimum_velocity + (maximum_velocity - minimum_velocity) * randf()
		DampedOscillator.animate(nodo, "scale", spring, damp, velocity, factor_scale)

# TODO: hacer que damped oscillator sea una tool
#func probar() -> void:
	#squash_stretch()
#func _notification(what: int) -> void:
	#match what:
		#NOTIFICATION_EDITOR_PRE_SAVE:
			#for nodo: Node3D in nodos:
				#nodo.scale = _escalas_iniciales(nodo)
