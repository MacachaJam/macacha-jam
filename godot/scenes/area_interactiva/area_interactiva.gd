class_name AreaInteractiva
extends Area3D
## Área que cuando se interactúa emite una señal y espera que la llamen.

signal inicio_interactuar
signal fin_interactuar

func interactuar() -> void:
	inicio_interactuar.emit()

func terminar_interacción():
	fin_interactuar.emit()
