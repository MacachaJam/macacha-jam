@tool
class_name Realista
extends CharacterBody3D

enum Modos { DORMIDO, YENDO, BUSCANDO }
@onready var signo_alerta: GPUParticles3D = %"Signo Alerta"

@onready var animated_sprite_3d: AnimatedSprite3D = %AnimatedSprite3D
@onready var atrapa_jugadora: Area3D = %AtrapaJugadora

@onready var realista_dormido: Node = %RealistaDormido
@onready var realista_yendo: Node = %RealistaYendo
@onready var realista_buscando: Node = %RealistaBuscando

@onready var _comportamientos: Array[Node] = [realista_dormido, realista_yendo, realista_buscando]

@export var flip_sprite: bool:
	set = _set_flip_sprite
@export var modo: Modos = Modos.DORMIDO:
	set = _set_modo

@export_range(10, 1000, 10, "or_greater", "suffix:m/s") var velocidad_buscar: float = 80.0
@export_range(10, 1000, 10, "or_greater", "suffix:m/s") var velocidad_correr: float = 150.0
@export_range(10, 1000, 10, "or_greater", "suffix:m/s") var velocidad_detenerse: float = 50.0


func _activar_comportamiento(nodo: Node) -> void:
	for c: Node in _comportamientos:
		c.process_mode = Node.PROCESS_MODE_INHERIT if c == nodo else Node.PROCESS_MODE_DISABLED

func _desactivar_todos_los_comportamientos() -> void:
	for c in _comportamientos:
		c.process_mode = Node.PROCESS_MODE_DISABLED

func _set_flip_sprite(nuevo_flip_sprite: bool) -> void:
	flip_sprite = nuevo_flip_sprite
	if not is_node_ready():
		return
	animated_sprite_3d.flip_h = flip_sprite

func _animar_alert() -> void:
	var r := 0.8 * randf()
	await get_tree().create_timer(r).timeout
	animated_sprite_3d.play("alert")
	await animated_sprite_3d.animation_finished
	animated_sprite_3d.play("idle")


func _set_modo(nuevo_modo: Modos) -> void:
	if Engine.is_editor_hint():
		return
	modo = nuevo_modo
	if not is_node_ready():
		return
	match modo:
		Modos.DORMIDO:
			_activar_comportamiento(realista_dormido)
		Modos.YENDO:
			_desactivar_todos_los_comportamientos()
			await _animar_alert()
			_activar_comportamiento(realista_yendo)
		Modos.BUSCANDO:
			_desactivar_todos_los_comportamientos()
			await _animar_alert()
			_activar_comportamiento(realista_buscando)

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	_set_flip_sprite(flip_sprite)
	GameState.scene.jugadora_descubierta.connect(_on_jugadora_descubierta)
	if GameState.global.hechos_del_dia.get("te_descubrieron"):
		# modo = Modos.BUSCANDO
		modo = Modos.YENDO
	else:
		_set_modo(modo)

func _on_jugadora_descubierta() -> void:
	# modo = Modos.BUSCANDO
	modo = Modos.YENDO

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return
	if animated_sprite_3d.animation == "alert":
		return
	if velocity.is_zero_approx():
		animated_sprite_3d.play("idle")
	else:
		animated_sprite_3d.play("walk")

	if not is_zero_approx(velocity.x):
		animated_sprite_3d.flip_h = velocity.x > 0


func _on_atrapa_jugadora_body_entered(_body: Node3D) -> void:
	GameState.te_atraparon()
	modo = Modos.DORMIDO


func _on_detecta_jugadora_body_entered(_body: Node3D) -> void:
	if modo == Modos.BUSCANDO:
		GameState.scene.jugadora_descubierta.emit()
		GameState.global.hechos_del_dia.te_descubrieron = true
