# SPDX-FileCopyrightText: The Threadbare Authors
# SPDX-License-Identifier: MPL-2.0
@tool
class_name Quest
extends Resource
## Information that defines a playable quest

## [Quest] resources must have this filename to be found by the game.
const FILENAME := "quest.tres"

## The quest's title. This should be short, like the title of a novel.
@export var title: String

## A short description of the quest. This should be a single paragraph of around 2–3 sentences.
@export_multiline var description: String

## The path to the first scene of the quest.
@export_file("*.tscn") var first_scene: String

## Lists all quests in [param quest_directory]; which is to say, all [Quest]
## resources named [const FILENAME] which are in an immediate subdirectory of
## [param quest_directory].
## [br][br]
## In Bash terms, this is: [code]$quest_directory/*/quest.tres[/code]
static func enumerate(quest_directory: String) -> Array[Quest]:
	var quests: Array[Quest] = []

	for dir in ResourceLoader.list_directory(quest_directory):
		var quest_path := quest_directory.path_join(dir).path_join(FILENAME)
		if ResourceLoader.exists(quest_path):
			var quest: Quest = ResourceLoader.load(quest_path)
			quests.append(quest)

	return quests


func _to_string() -> String:
	var subclass_name: StringName = (get_script() as Script).get_global_name()
	return '<%s %s: "%s">' % [subclass_name, resource_path, title]


## Returns [member title] if set, or a placeholder identifying the quest otherwise.
func get_title() -> String:
	if title:
		return title

	return resource_path.get_base_dir().get_file()
