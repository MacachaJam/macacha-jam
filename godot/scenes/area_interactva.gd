extends Area3D

const HOLA = preload("uid://dethlbsdqk344")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(_body: Node3D) -> void:
	DialogueManager.show_dialogue_balloon(HOLA)
