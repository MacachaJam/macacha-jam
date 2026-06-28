class_name PuntitoInterfazSilabeador
extends Node2D

@export var altura: float = 100
@export var velocidad: float = 40
@export var índice_sílaba: int

@onready var animatable_body_2d: AnimatableBody2D = %AnimatableBody2D
@onready var collision_shape_2d: CollisionShape2D = %CollisionShape2D

var iniciado := false

func _ready() -> void:
	animatable_body_2d.visible = false
	collision_shape_2d.disabled = true

func _physics_process(delta: float) -> void:
	if not iniciado:
		animatable_body_2d.position.y = -altura
		iniciado = true
		collision_shape_2d.disabled = false
		return
	animatable_body_2d.visible = true
	animatable_body_2d.position.y += velocidad * delta
	# Lo debería liberar la interfaz al colisionar,
	# esto es sólo por las dudas.
	if animatable_body_2d.position.y >= 0:
		queue_free()
