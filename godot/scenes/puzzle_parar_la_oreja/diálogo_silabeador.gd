class_name DiálogoSilabeador
extends Node

var globo: Globo

func iniciar() -> void:
	var balloon_path: String = DMSettings.get_setting(DMSettings.BALLOON_PATH, "uid://d3ek7b2j51084")
	globo = load(balloon_path).instantiate()
	get_parent().add_child.call_deferred(globo)
	if not globo.is_node_ready():
		await globo.ready
	globo.dialogue_label.text = ""
	globo.character_label.text = "José de la Serna (bajito)"
	globo.show()
	globo.balloon.show()
	globo.dialogue_label.text = ""

func agregar_sílaba(texto: String, color: Color, última: bool = false) -> void:
	globo.dialogue_label.push_color(color)
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
