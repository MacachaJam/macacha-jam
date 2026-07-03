# SPDX-FileCopyrightText: The Threadbare Authors
# SPDX-License-Identifier: MPL-2.0
@tool
class_name GlobalState
extends Resource

signal cambió_atuendo

@export var dia_actual: int = 1
@export var atuendo_actual: Jugadora.Atuendos = Jugadora.Atuendos.VESTIDO:
	set = _set_atuendo_actual

func _set_atuendo_actual(nuevo_atuendo: Jugadora.Atuendos) -> void:
	atuendo_actual = nuevo_atuendo
	cambió_atuendo.emit()

## Generic game state facts. For quests, use [member QuestState.facts] instead.
@export var facts: Dictionary[String, Variant]

## Global player state. During a quest, [member QuestState.player] should be
## used instead. [GameState.player] always points to the correct instance.
@export var player: PlayerState = PlayerState.new()
