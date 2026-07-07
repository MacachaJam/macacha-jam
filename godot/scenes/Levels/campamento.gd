extends Node3D

@export_range(0, 10, 0.1, "or_more") var duración_overlay: float = 0.5
@export_range(0, 10, 0.1, "or_more") var duración_fundido_overlay: float = 2.0
@export var diálogo: DialogueResource = preload("uid://cf37hqituw4s6")

@onready var jugadora: Jugadora = %Jugadora
@onready var desde_el_centro: SpawnPoint = %DesdeElCentro
@onready var overlay_dia: Control = %OverlayDia
@onready var label_dia: Label = $UI/OverlayDia/CenterContainer/LabelDia


func _ready() -> void:
	overlay_dia.hide()
	if GameState.global.hechos_del_dia.get("te_descubrieron"):
		DialogueManager.show_dialogue_balloon(diálogo, "mision_incompleta")
	elif not jugadora.global_position.is_equal_approx(desde_el_centro.global_position):
		mostrar_overlay_día()


func mostrar_overlay_día() -> void:
		label_dia.text = "DÍA %d" % GameState.global.dia_actual
		overlay_dia.show()
		await get_tree().create_timer(duración_overlay).timeout
		var tween := create_tween()
		tween.tween_property(overlay_dia, "modulate:a", 0.0, duración_fundido_overlay)
		await tween.finished
		overlay_dia.hide()
