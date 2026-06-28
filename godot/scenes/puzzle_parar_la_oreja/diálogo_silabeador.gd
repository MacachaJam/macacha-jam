class_name DiálogoSilabeador
extends Node

const GLOBO = preload("uid://d3ek7b2j51084")

var globo: Globo

var colores_x_precisión: Dictionary[PuzzlePararLaOreja.Precisiones, Color] = {
	PuzzlePararLaOreja.Precisiones.BIEN: Color(0.568, 0.947, 0.355, 1.0),
	PuzzlePararLaOreja.Precisiones.MASO: Color(0.912, 0.684, 0.303, 1.0),
	PuzzlePararLaOreja.Precisiones.MAAL: Color(1.0, 0.396, 0.423, 1.0),
}

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

func agregar_sílaba(texto: String, precisión: PuzzlePararLaOreja.Precisiones, última: bool = false) -> void:
	globo.dialogue_label.push_color(colores_x_precisión[precisión])
	globo.dialogue_label.append_text(texto)
	globo.dialogue_label.pop()
	if not última:
		globo.dialogue_label.append_text("-")

func revelar_frase(frase: String) -> void:
	globo.dialogue_label.text = "[wave amp=50.0 freq=5.0 connected=1]" + frase + "[/wave]"
	await get_tree().create_timer(10.0).timeout
	globo.queue_free()

func no_entendí() -> void:
	globo.dialogue_label.text = "[shake rate=20.0 level=5.0 connected=1]¿¿¿???[/shake]"
	await get_tree().create_timer(4.0).timeout
	globo.queue_free()
