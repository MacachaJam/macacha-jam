class_name InterfazMaiz
extends Node2D

@onready var animation_player: AnimationPlayer = %AnimationPlayer

func _ready() -> void:
	desactivar()

func desactivar() -> void:
	visible = false
	process_mode = Node.PROCESS_MODE_DISABLED

func _physics_process(_delta: float) -> void:
	if animation_player.is_playing():
		return
	if Input.is_action_pressed("move_left"):
		animation_player.play("Ausente")
	elif Input.is_action_pressed("move_right"):
		animation_player.play("Presente")

func iniciar() -> void:
	visible = true
	process_mode = Node.PROCESS_MODE_INHERIT
