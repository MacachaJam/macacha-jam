# SPDX-FileCopyrightText: The Threadbare Authors
# SPDX-License-Identifier: MPL-2.0
class_name SavedGame
extends Resource

## Game-wide state
@export var global: GlobalState = GlobalState.new()

## State concerning the scene that the player is currently playing.
@export var scene: PerSceneState
