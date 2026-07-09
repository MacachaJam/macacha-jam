# SPDX-FileCopyrightText: The Threadbare Authors
# SPDX-License-Identifier: MPL-2.0
@tool
class_name GlobalState
extends Resource

signal cambió_atuendo

var hechos_inicial: Dictionary[String, Variant] = {
	"hablaste_con_macacha": false,
	"conseguiste_la_info": false,
	"te_descubrieron": false,
	"te_capturaron": false,
}


@export var dia_actual: int = 1
@export var atuendo_actual: Jugadora.Atuendos = Jugadora.Atuendos.VESTIDO:
	set = _set_atuendo_actual

## Los hechos del día.
@export var hechos_del_dia: Dictionary[String, Variant] = hechos_inicial.duplicate()

func pasar_de_dia() -> void:
	dia_actual += 1
	hechos_del_dia = hechos_inicial.duplicate()

func _set_atuendo_actual(nuevo_atuendo: Jugadora.Atuendos) -> void:
	atuendo_actual = nuevo_atuendo
	cambió_atuendo.emit()
