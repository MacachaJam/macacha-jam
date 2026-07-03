# SPDX-FileCopyrightText: The Threadbare Authors
# SPDX-License-Identifier: MPL-2.0
@tool
class_name GlobalState
extends Resource

@export var dia_actual: int = 1

## Generic game state facts. For quests, use [member QuestState.facts] instead.
@export var facts: Dictionary[String, Variant]

## Global player state. During a quest, [member QuestState.player] should be
## used instead. [GameState.player] always points to the correct instance.
@export var player: PlayerState = PlayerState.new()
