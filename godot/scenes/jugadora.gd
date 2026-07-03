class_name Jugadora
extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@onready var animated_sprite_3d: AnimatedSprite3D = $AnimatedSprite3D

var _detenida: bool

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
	else:
		animated_sprite_3d.play("caminando")

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
