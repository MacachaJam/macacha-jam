# SPDX-FileCopyrightText: The Threadbare Authors
# SPDX-License-Identifier: MPL-2.0
@tool
class_name SpawnPoint
extends Marker3D

## Emitted after the player position has been changed.
## [br][br]
## Level scenes can use this signal to behave differently depending on
## which SpawnPoint was used (or if no SpawnPoint at all was used).
signal player_teleported


func _init() -> void:
	add_to_group("spawn_point", true)


func _ready() -> void:
	if Engine.is_editor_hint():
		return

	if GameState.scene.spawn_point == get_tree().current_scene.get_path_to(self):
		move_player_to_self_position()


func move_player_to_self_position() -> void:
	var player: Node3D = get_tree().get_first_node_in_group("player")
	if not player:
		return
	player.global_position = global_position
	player_teleported.emit()
