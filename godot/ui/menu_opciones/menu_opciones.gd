extends Node2D

@onready var return_button := %ReturnButton
@onready var UISFX: AudioStreamPlayer = $UISFX

func _ready():
	return_button.pressed.connect(_on_return_button_pressed)
	return_button.grab_focus()

func _on_return_button_pressed():
	UISFX.play()
	SceneSwitcher.change_to_file_with_transition(
		"res://ui/menu_principal/menu_principal.tscn",
		"",
		Transition.Effect.FADE,
		Transition.Effect.FADE,
	)
