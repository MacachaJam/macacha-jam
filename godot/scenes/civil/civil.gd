class_name Civil
extends CharacterBody3D

enum Personaje { VARON_1, VARON_2, MUJER_1, MUJER_2 }

@export var personaje: Personaje:
	set = _set_personaje

@onready var animated_sprite_3d: AnimatedSprite3D = %AnimatedSprite3D

var sprite_frames_x_personaje: Dictionary[Personaje, SpriteFrames] = {
	Personaje.VARON_1: preload("uid://cdyv603u07qoe"),
	Personaje.VARON_2: preload("uid://cyichd4hnvarg"),
	Personaje.MUJER_1: preload("uid://dkx6x7h4q1knw"),
	Personaje.MUJER_2: preload("uid://djylhux8ibnwt"),
}

func _set_personaje(nuevo_personaje: Personaje) -> void:
	personaje = nuevo_personaje

	if not is_node_ready():
		return
	animated_sprite_3d.sprite_frames = sprite_frames_x_personaje[personaje]
	animated_sprite_3d.animation_changed.emit()

func _ready() -> void:
	_set_personaje(personaje)

func _process(_delta: float) -> void:
	if velocity.is_zero_approx():
		animated_sprite_3d.play("idle")
	else:
		animated_sprite_3d.play("walk")

	if not is_zero_approx(velocity.x):
		animated_sprite_3d.flip_h = velocity.x > 0
