class_name AreaInteractiva
extends Area3D
## Área que cuando se interactúa emite una señal y espera que la llamen.

signal inicio_interactuar
signal fin_interactuar

func interactuar() -> void:
	inicio_interactuar.emit()
	#set_deferred("monitoring", false)
	#set_deferred("monitorable", false)

func terminar_interacción():
	fin_interactuar.emit()
	await get_tree().create_timer(0.5).timeout
	#set_deferred("monitoring", true)
	#set_deferred("monitorable", true)
