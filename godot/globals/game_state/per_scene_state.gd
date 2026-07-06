# SPDX-FileCopyrightText: The Threadbare Authors
# SPDX-License-Identifier: MPL-2.0
class_name PerSceneState
extends Resource
## State concerning the current scene in the game.
##
## This state is replaced whenever the game changes scene.

signal jugadora_teletrasportada
signal jugadora_descubierta

## The path to the current scene.
@export var path: String

## Path to the current spawn point within the scene at [member path], or
## [code]^""[/code] if the player should spawn at the default position when
## reloading the scene.
@export var spawn_point: NodePath:
	set = set_spawn_point

@export var debug_descubierta: bool:
	set = _set_debug_descubierta


@export var ya_te_atraparon: bool = false


func _init(scene_path: String = "") -> void:
	path = scene_path


func set_spawn_point(new_value: NodePath) -> void:
	spawn_point = new_value
	emit_changed()

func _set_debug_descubierta(b: bool) -> void:
	debug_descubierta = b
	if debug_descubierta:
		jugadora_descubierta.emit()
	
