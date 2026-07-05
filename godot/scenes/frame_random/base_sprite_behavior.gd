# SPDX-FileCopyrightText: The Threadbare Authors
# SPDX-License-Identifier: MPL-2.0
@tool
@abstract class_name BaseSpriteBehavior
extends Node3D
## @experimental
##
## Base class for sprite behaviors.

## The controlled sprite.
## [br][br]
## [b]Note:[/b] If the parent node is a AnimatedSprite2D and this isn't set,
## the parent node will be automatically assigned to this variable.
@export var sprite: AnimatedSprite3D:
	set = _set_sprite


func _enter_tree() -> void:
	if not sprite and get_parent() is AnimatedSprite3D:
		sprite = get_parent()


func _set_sprite(new_sprite: AnimatedSprite3D) -> void:
	sprite = new_sprite
	update_configuration_warnings()


func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray
	if sprite is not AnimatedSprite3D:
		warnings.append("Sprite must be set.")
	return warnings
