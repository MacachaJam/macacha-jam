class_name AreaInteractivaDiálogo
extends AreaInteractiva
## Área que cuando se interactúa muestra un diálogo.

@export var diálogo: DialogueResource = preload("uid://dethlbsdqk344")

func interactuar() -> void:
	super()
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended, CONNECT_ONE_SHOT)
	DialogueManager.show_dialogue_balloon(diálogo)

func _on_dialogue_ended(_resource: DialogueResource):
	fin_interactuar.emit()
