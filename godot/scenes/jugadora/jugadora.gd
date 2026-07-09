class_name Jugadora
extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

enum Atuendos { VESTIDO, VENDEDORA, CRIADA }

@export var atuendo: Atuendos:
	set = _set_atuendo

@export var sprite_frames_x_atuendo: Dictionary[Atuendos, SpriteFrames] = {
	Atuendos.VESTIDO: preload("uid://b4e0qc27oqlte"),
	Atuendos.VENDEDORA: preload("uid://dl6i2sypsjbev"),
	Atuendos.CRIADA: preload("uid://5qddwg2qyvb3"),
}

@onready var animated_sprite_3d: AnimatedSprite3D = %AnimatedSprite3D
@onready var pasos_sfx: AudioStreamPlayer = %PasosSFX
@onready var cambiar_vestido_sfx: AudioStreamPlayer = %CambiarVestidoSFX
@onready var atrapada_sfx: AudioStreamPlayer = %AtrapadaSFX

var _detenida: bool
var _abanicar: bool

func _set_atuendo(nuevo_atuendo: Atuendos) -> void:
	atuendo = nuevo_atuendo

	if not is_node_ready():
		return
	animated_sprite_3d.sprite_frames = sprite_frames_x_atuendo[atuendo]

func _ready() -> void:
	if atuendo != GameState.global.atuendo_actual:
		atuendo = GameState.global.atuendo_actual
	GameState.global.cambió_atuendo.connect(_on_gamestate_cambió_atuendo)
	Transitions.started.connect(_on_transition_started)
	GameState.atrapada.connect(_on_gamestate_atrapada)


func _on_gamestate_cambió_atuendo() -> void:
	atuendo = GameState.global.atuendo_actual
	cambiar_vestido_sfx.play()

func _on_transition_started() -> void:
	cambiar_detenida(true)

func _on_gamestate_atrapada() -> void:
	cambiar_detenida(true)
	atrapada_sfx.play()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if not _detenida:
		_moverse_con_input(delta)
	else:
		velocity.x = 0
		velocity.z = 0

	if velocity.is_zero_approx():
		# Caso especial abanicar:
		if _abanicar and animated_sprite_3d.sprite_frames.has_animation("saca_abanico") and animated_sprite_3d.sprite_frames.has_animation("abanicándose"):
			if animated_sprite_3d.animation not in ["saca_abanico", "abanicándose"]:
				animated_sprite_3d.play("saca_abanico")
				await animated_sprite_3d.animation_finished
				animated_sprite_3d.play("abanicándose")
		else:
			animated_sprite_3d.play("parada")
		if pasos_sfx.playing:
			pasos_sfx.stop()
	else:
		animated_sprite_3d.play("caminando")
		if not pasos_sfx.playing:
			pasos_sfx.play()

	if not is_zero_approx(velocity.x):
		animated_sprite_3d.flip_h = velocity.x > 0


	move_and_slide()
	
func _moverse_con_input(_delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

func cambiar_detenida(detenida: bool) -> void:
	_detenida = detenida

func cambiar_abanicar(abanicar: bool) -> void:
	_abanicar = abanicar
