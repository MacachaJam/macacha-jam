extends Node

const MELODIA := preload("res://Audio/Music/Macacha-MelodiaGameplay_MIfrigio_BPM160_3x4.ogg")
const TENSION := preload("res://Audio/Music/TensionGameplay_MIfrigio_BPM160_3x4.ogg")
const BOMBO := preload("res://Audio/Music/Bombo.tres")
const ACOMPANAMIENTO := preload("res://Audio/Music/Acompanamiento.tres")

const CLIP_NAMES := [
	&"chacarera",
	&"vidala",
	&"zamba",
]

const CAPA_MELODIA := 0
const CAPA_TENSION := 1
const CAPA_BOMBO := 2
const CAPA_ACOMPANAMIENTO := 3

var tension_activa := false

func _ready() -> void:
	AudioManager.play_layer(CAPA_MELODIA, MELODIA)
	AudioManager.play_layer_silent(CAPA_TENSION, TENSION)  # arranca en silencio, en fase
	AudioManager.play_layer(CAPA_BOMBO, BOMBO, CLIP_NAMES[0])
	AudioManager.play_layer(CAPA_ACOMPANAMIENTO, ACOMPANAMIENTO, CLIP_NAMES[0])

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_1:
				cambiar_ritmo(0)
			KEY_2:
				cambiar_ritmo(1)
			KEY_3:
				cambiar_ritmo(2)
			KEY_T:
				toggle_tension()

func cambiar_ritmo(nivel: int) -> void:
	print("Intensidad: ", CLIP_NAMES[nivel])
	AudioManager.switch_layer_clip(CAPA_BOMBO, CLIP_NAMES[nivel])
	AudioManager.switch_layer_clip(CAPA_ACOMPANAMIENTO, CLIP_NAMES[nivel])

func toggle_tension() -> void:
	tension_activa = not tension_activa
	if tension_activa:
		print("Tension ON")
		AudioManager.unmute_layer(CAPA_TENSION, 0.5)
	else:
		print("Tension OFF")
		AudioManager.mute_layer(CAPA_TENSION, 0.5)
