class_name PuntitoInterfazSilabeador
extends Node2D

@export var altura_inicial: float = 100
@export var velocidad: float = 40
@export var índice_sílaba: int

@onready var animatable_body_2d: AnimatableBody2D = %AnimatableBody2D
@onready var collision_shape_2d: CollisionShape2D = %CollisionShape2D

@onready var centro_label: Node2D = %CentroLabel
@onready var label: RichTextLabel = %Label
@onready var animation_player: AnimationPlayer = %AnimationPlayer

var iniciado := false

func _ready() -> void:
	animatable_body_2d.visible = false
	collision_shape_2d.disabled = true

func _physics_process(delta: float) -> void:
	if not iniciado:
		animatable_body_2d.position.y = -altura_inicial
		iniciado = true
		collision_shape_2d.disabled = false
		animation_player.play("iniciar")
		return
	animatable_body_2d.position.y += velocidad * delta
	# Lo debería liberar la interfaz al colisionar con el centro,
	# esto es sólo por las dudas.
	if animatable_body_2d.position.y >= 100:
		queue_free()


func transformar_en_sílaba(texto: String, color: Color) -> void:
	label.text = ""
	label.push_color(color)
	label.append_text(texto)
	label.pop()
	animation_player.play("transformar")
	await animation_player.animation_finished
	queue_free()
