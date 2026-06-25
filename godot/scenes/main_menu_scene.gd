extends Node2D

@export var game_scene:PackedScene
@export var settings_scene:PackedScene

@onready var continue_button := %ContinueButton
@onready var new_game_button := %NewGameButton
@onready var settings_button := %SettingsButton
@onready var exit_button := %ExitButton

func _ready() -> void:
	new_game_button.disabled = game_scene == null
	settings_button.disabled = settings_scene == null
	continue_button.visible = SaveGame.has_save() and SaveGame.ENABLED
	
	# connect signals
	new_game_button.pressed.connect(_on_play_button_pressed)
	continue_button.pressed.connect(_on_continue_button_pressed)
	settings_button.pressed.connect(_on_settings_button_pressed)
	exit_button.pressed.connect(_on_exit_button_pressed)
	
	exit_button.visible = OS.get_name() != "Web"
	
	if continue_button.visible:
		continue_button.grab_focus()
	else:
		new_game_button.grab_focus()

func _on_settings_button_pressed() -> void:
	SceneSwitcher.change_to_packed_with_transition(
		settings_scene,
		"",
		Transition.Effect.FADE,
		Transition.Effect.FADE,
	)
	
func _on_play_button_pressed() -> void:
	if SaveGame.has_save():
		SaveGame.delete_save()

	SceneSwitcher.change_to_packed_with_transition(
		game_scene,
		"",
		Transition.Effect.FADE,
		Transition.Effect.FADE,
	)
	
func _on_continue_button_pressed() -> void:
	if SaveGame.has_save():
		SaveGame.load_game(get_tree())

	SceneSwitcher.change_to_packed_with_transition(
		game_scene,
		"",
		Transition.Effect.FADE,
		Transition.Effect.FADE,
	)

func _on_exit_button_pressed() -> void:
	await Transitions.do_out_transition()
	get_tree().quit.call_deferred()
