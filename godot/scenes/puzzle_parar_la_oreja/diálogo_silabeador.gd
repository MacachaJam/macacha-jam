class_name DiálogoSilabeador
extends Node

const GLOBO = preload("uid://d3ek7b2j51084")

var globo: Globo


func iniciar() -> void:
	globo = GLOBO.instantiate()
	get_parent().add_child.call_deferred(globo)
	if not globo.is_node_ready():
		await globo.ready
	globo.dialogue_label.text = ""
	globo.character_label.text = "José de la Serna"
	globo.show()
	globo.balloon.show()
	globo.dialogue_label.text = ""

func agregar_sílaba(texto: String, última: bool = false) -> void:
	globo.dialogue_label.text += texto
	if not última:
		globo.dialogue_label.text += "-"

func mostrar_resultado(texto: String) -> void:
	globo.dialogue_label.text = "[wave amp=50.0 freq=5.0 connected=1]" + texto + "[/wave]"
	await get_tree().create_timer(10.0).timeout

	globo.queue_free()
