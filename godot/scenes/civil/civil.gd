class_name Civil
extends CharacterBody3D

signal llegó

enum Personaje { VARON_1, VARON_2, MUJER_1, MUJER_2 }

@export var personaje: Personaje:
	set = _set_personaje

@export var sprite_frames_x_personaje: Dictionary[Personaje, SpriteFrames] = {
	Personaje.VARON_1: preload("uid://cdyv603u07qoe"),
	Personaje.VARON_2: preload("uid://cyichd4hnvarg"),
	Personaje.MUJER_1: preload("uid://dkx6x7h4q1knw"),
	Personaje.MUJER_2: preload("uid://djylhux8ibnwt"),
}

@export_range(10, 1000, 10, "or_greater", "suffix:m/s") var velocidad_caminar: float = 300.0
@export_range(10, 1000, 10, "or_greater", "suffix:m/s") var velocidad_detenerse: float = 50.0

@onready var animated_sprite_3d: AnimatedSprite3D = %AnimatedSprite3D
@onready var agent: NavigationAgent3D = %NavigationAgent3D

func _set_personaje(nuevo_personaje: Personaje) -> void:
	personaje = nuevo_personaje

	if not is_node_ready():
		return
	animated_sprite_3d.sprite_frames = sprite_frames_x_personaje[personaje]
	animated_sprite_3d.animation_changed.emit()

func _ready() -> void:
	_set_personaje(personaje)
	agent.target_reached.connect(_on_target_reached)
	agent.navigation_finished.connect(_on_navigation_finished)

func ir_a(global_pos: Vector3) -> void:
	agent.target_position = global_pos

func _on_target_reached() -> void:
	llegó.emit()

func _on_navigation_finished() -> void:
	llegó.emit()

func _physics_process(delta: float) -> void:
	if agent.is_navigation_finished():
		velocity.x = move_toward(velocity.x, 0, velocidad_detenerse * delta)
		velocity.z = move_toward(velocity.z, 0, velocidad_detenerse * delta)
	else:
		var d := agent.get_next_path_position()
		var dl := d - global_position
		var direction := dl.normalized()

		if direction:
			velocity.x = direction.x * velocidad_caminar * delta
			velocity.z = direction.z * velocidad_caminar * delta
		else:
			velocity.x = move_toward(velocity.x, 0, velocidad_caminar * delta)
			velocity.z = move_toward(velocity.z, 0, velocidad_caminar * delta)

	move_and_slide()

func _process(_delta: float) -> void:
	if velocity.is_zero_approx():
		animated_sprite_3d.play("idle")
	else:
		animated_sprite_3d.play("walk")

	if not is_zero_approx(velocity.x):
		animated_sprite_3d.flip_h = velocity.x > 0
