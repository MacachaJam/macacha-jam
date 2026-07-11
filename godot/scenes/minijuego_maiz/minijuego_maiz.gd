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
	_ausentes = 0
	_presentes = 0
	interfaz.ausente.connect(_on_ausente)
	interfaz.presente.connect(_on_presente)
	interfaz.iniciar()

	var controles: ControlesPantalla = get_tree().get_first_node_in_group("controles_pantalla") as ControlesPantalla
	if controles:
		controles.cambiar_izq_der(true)

	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
	DialogueManager.show_dialogue_balloon(diálogo)

func _on_dialogue_ended(resource: DialogueResource) -> void:
	if resource != diálogo:
		# Terminó otro diálogo, no el de pasar lista.
		return
	await get_tree().create_timer(2).timeout
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

	if _ausentes != ausentes_posta:
		prints("contaste %d ausentes pero son %d" % [_ausentes, ausentes_posta])
	if _presentes != presentes_posta:
		prints("contaste %d presentes pero son %d" % [_presentes, presentes_posta])
	DialogueManager.dialogue_ended.disconnect(_on_dialogue_ended)
	fin_del_minijuego.emit(_ausentes == ausentes_posta and _presentes == presentes_posta)
