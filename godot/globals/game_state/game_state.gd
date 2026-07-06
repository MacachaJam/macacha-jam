# SPDX-FileCopyrightText: The Threadbare Authors
# SPDX-License-Identifier: MPL-2.0
extends Node

signal atrapada

const SAVE_PATH := "user://saved_game.tres"


## Scenes to skip from saving.
const TRANSIENT_SCENES := [
	"res://ui/menu_principal/menu_principal.tscn",
	"res://ui/menu_opciones/menu_opciones.tscn",
]

## The progress is persisted only if the game is run normally from the main scene.
## Otherwise, it means we are playing a specific scene: the current scene from the editor or
## with a direct URL hash to a scene in the web build. In the latter cases, this variable is false.
var persist_progress: bool

## Game-wide state.
var global: GlobalState:
	get():
		return _saved_game.global if _saved_game else null
	set(new_value):
		push_error("Do not set GameState.global")


## State concerning the current scene, or [code]null[/code] if there is no current scene
var scene: PerSceneState:
	get():
		return _saved_game.scene if _saved_game else null
	set(new_value):
		_saved_game.scene = new_value


var _saved_game: SavedGame


func _ready() -> void:
	if Engine.is_editor_hint():
		return

	if ResourceLoader.exists(SAVE_PATH):
		_saved_game = ResourceLoader.load(SAVE_PATH, "", ResourceLoader.CACHE_MODE_REPLACE_DEEP)

	if not _saved_game:
		_saved_game = SavedGame.new()

	var current_scene := get_tree().current_scene
	var initial_scene_uid := (
		ResourceLoader.get_resource_uid(current_scene.scene_file_path) if current_scene else -1
	)
	var main_scene_uid := ResourceLoader.get_resource_uid(
		ProjectSettings.get_setting("application/run/main_scene")
	)
	persist_progress = initial_scene_uid == main_scene_uid
	if not persist_progress:
		# TODO: estado de ejemplo acá para la current_scene
		# prints(current_scene)
		return


## Set the scene path and [member current_spawn_point], and save the game.
func set_scene(scene_path: String, spawn_point: NodePath = ^"") -> void:
	if scene_path in TRANSIENT_SCENES:
		return

	if not scene or scene.path != scene_path:
		scene = PerSceneState.new(scene_path)

	scene.spawn_point = spawn_point
	save()


## Clear the persisted state.
func clear() -> void:
	_saved_game = SavedGame.new()


## Check if there is persisted state.
func can_restore() -> bool:
	return scene != null


## Save the game state (if [persist_progress] is [code]true[/code])
func save() -> void:
	if not persist_progress:
		return

	var e := ResourceSaver.save(_saved_game, SAVE_PATH)
	if e != OK:
		push_error("Failed to save state to %s: %d %s" % [SAVE_PATH, e, error_string(e)])

func te_atraparon() -> void:
	if not scene.ya_te_atraparon:
		scene.ya_te_atraparon = true
		atrapada.emit()
		SceneSwitcher.change_to_file_with_transition("uid://bo4k0aec7e628", "", Transition.Effect.FADE, Transition.Effect.FADE)
