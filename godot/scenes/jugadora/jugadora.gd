class_name Jugadora
extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

enum Atuendos { VESTIDO, VENDEDORA, CRIADA }

@export var atuendo: Atuendos:
	set = _set_atuendo

@onready var animated_sprite_3d: AnimatedSprite3D = %AnimatedSprite3D
@onready var pasos_sfx: AudioStreamPlayer = %PasosSFX
@onready var cambiar_vestido_sfx: AudioStreamPlayer = %CambiarVestidoSFX
@onready var atrapada_sfx: AudioStreamPlayer = %AtrapadaSFX

var sprite_frames_x_atuendo: Dictionary[Atuendos, SpriteFrames] = {
	Atuendos.VESTIDO: preload("uid://b4e0qc27oqlte"),
	Atuendos.VENDEDORA: preload("uid://dl6i2sypsjbev"),
	Atuendos.CRIADA: preload("uid://5qddwg2qyvb3"),
}
var _detenida: bool

func _set_atuendo(nuevo_atuendo: Atuendos) -> void:
	atuendo = nuevo_atuendo

	if not is_node_ready():
		return
	animated_sprite_3d.sprite_frames = sprite_frames_x_atuendo[atuendo]

func _ready() -> void:
	if atuendo != GameState.global.atuendo_actual:
		_on_gamestate_cambió_atuendo()
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
		animated_sprite_3d.play("parada")
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
