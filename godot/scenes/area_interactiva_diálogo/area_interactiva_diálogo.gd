extends Area3D
## Área que cuando se interactúa muestra un diálogo.
## Muestra un indicador cuando se puede interactuar.

signal fin_interactuar

@export var diálogo: DialogueResource = preload("uid://dethlbsdqk344")

func interactuar() -> void:
	DialogueManager.show_dialogue_balloon(diálogo)
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

func _on_dialogue_ended(_resource: DialogueResource):
	fin_interactuar.emit()
