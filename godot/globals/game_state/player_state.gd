# SPDX-FileCopyrightText: The Threadbare Authors
# SPDX-License-Identifier: MPL-2.0
@tool
class_name PlayerState
extends Resource

const MAX_LIVES := 3

## Current number of lives the player has.
@export_range(0, MAX_LIVES, 1) var lives: int = MAX_LIVES:
	set(value):
		lives = value
		emit_changed()


## Reduces [member lives] by 1.
func decrement_lives() -> void:
	lives = max(0, lives - 1)


## Resets [member lives] to [const MAX_LIVES].
func reset_lives() -> void:
	lives = MAX_LIVES
