extends Area3D
## Área que cuando se entra muestra un diálogo.
## El diálogo se tendría que pasar automáticamente, por ejemplo agregando
## [next=auto] o parecido en cada línea. Y no tendría que tener opciones.

@export var diálogo: DialogueResource = preload("uid://dethlbsdqk344")

var mostrando_diálogo := false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(_body: Node3D) -> void:
	if mostrando_diálogo:
		return
	var nodo := DialogueManager.show_dialogue_balloon(diálogo)
	mostrando_diálogo = true
	nodo.tree_exited.connect(_on_fin_diálogo)

func _on_fin_diálogo() -> void:
	mostrando_diálogo = false
