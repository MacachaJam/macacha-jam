class_name ControlaPosiciónSuave
extends Node
## Controla la posición de [member nodo_movido]. La mueve todo el tiempo suavemente a la
## posición de [member nodo_objetivo]. Útil para por ej. hace que una cámara siga a la
## jugadora.

@export var nodo_movido: Node3D
@export var nodo_objetivo: Node3D
@export_range(0.0, 1.0, 0.01) var peso: float = 0.05


func _process(_delta: float) -> void:
	nodo_movido.position = lerp(nodo_movido.position, nodo_objetivo.position, peso)
