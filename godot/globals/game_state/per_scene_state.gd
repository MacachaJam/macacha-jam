# SPDX-FileCopyrightText: The Threadbare Authors
# SPDX-License-Identifier: MPL-2.0
class_name PerSceneState
extends Resource
## State concerning the current scene in the game.
##
## This state is replaced whenever the game changes scene.

signal jugadora_teletrasportada

## The path to the current scene.
@export var path: String

## Path to the current spawn point within the scene at [member path], or
## [code]^""[/code] if the player should spawn at the default position when
## reloading the scene.
@export var spawn_point: NodePath:
	set = set_spawn_point

## Set when any introductory dialogue has been played for the current scene.
@export var intro_dialogue_shown: bool


func _init(scene_path: String = "") -> void:
	path = scene_path


func set_spawn_point(new_value: NodePath) -> void:
	spawn_point = new_value
	emit_changed()
