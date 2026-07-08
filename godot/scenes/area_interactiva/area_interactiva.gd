class_name AreaInteractiva
extends Area3D
## Área que cuando se interactúa emite una señal y espera que la llamen.

signal inicio_interactuar
signal fin_interactuar(desactivada: bool)

func _ready() -> void:
	set_collision_layer_value(3, true)

func interactuar() -> void:
	inicio_interactuar.emit()
	set_collision_layer_value(3, false)

func terminar_interacción(desactivar: bool = false):
	fin_interactuar.emit(desactivar)
	if not desactivar:
		await get_tree().create_timer(1).timeout
		set_collision_layer_value(3, true)
