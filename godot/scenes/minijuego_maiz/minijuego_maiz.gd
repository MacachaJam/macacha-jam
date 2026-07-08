class_name MinijuegoMaiz
extends Node

signal fin_del_minijuego(éxito: bool)

@export_range(0, 10, 1, "or_greater") var ausentes_posta: int = 4
@export_range(0, 10, 1, "or_greater") var presentes_posta: int = 6

# El diálogo tienen que tener un título "pasando_lista"
# y se tiene que reproducir automáticamente, cada línea con [next=auto] o simil.
@export var diálogo: DialogueResource

@export var interfaz: InterfazMaiz

var _ausentes: int
var _presentes: int

func iniciar() -> void:
	interfaz.ausente.connect(_on_ausente)
	interfaz.presente.connect(_on_presente)
	interfaz.iniciar()

	var controles: ControlesPantalla = get_tree().get_first_node_in_group("controles_pantalla") as ControlesPantalla
	if controles:
		controles.cambiar_izq_der(true)

	DialogueManager.show_dialogue_balloon(diálogo, "pasando_lista")
	await DialogueManager.dialogue_ended
	await get_tree().create_timer(1).timeout

	terminar()

func _on_ausente() -> void:
	_ausentes += 1

func _on_presente() -> void:
	_presentes += 1

func terminar() -> void:
	interfaz.ausente.disconnect(_on_ausente)
	interfaz.presente.disconnect(_on_presente)
	interfaz.desactivar()

	var controles: ControlesPantalla = get_tree().get_first_node_in_group("controles_pantalla") as ControlesPantalla
	if controles:
		controles.cambiar_izq_der(false)

	fin_del_minijuego.emit(_ausentes == ausentes_posta and _presentes == presentes_posta)
