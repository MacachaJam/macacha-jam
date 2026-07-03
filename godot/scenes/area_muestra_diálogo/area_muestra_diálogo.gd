class_name AreaMuestraDiálogo
extends Area3D
## Área que cuando se entra muestra un diálogo.
## El diálogo se tendría que pasar automáticamente, por ejemplo agregando
## [next=auto] o parecido en cada línea. Y no tendría que tener opciones.

@export var diálogo: DialogueResource = preload("uid://dethlbsdqk344")

var _globo_diálogo: Globo

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(_body: Node3D) -> void:
	if _globo_diálogo:
		return
	_globo_diálogo = DialogueManager.show_dialogue_balloon(diálogo)
	_globo_diálogo.tree_exited.connect(_on_fin_diálogo)

func _on_body_exited(_body: Node3D) -> void:
	if not _globo_diálogo:
		return
	_globo_diálogo.queue_free()

func _on_fin_diálogo() -> void:
	_globo_diálogo = null
