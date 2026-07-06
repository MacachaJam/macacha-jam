class_name InterfazSilabeador
extends Node2D

const PUNTITO = preload("uid://bhm2harux28fv")

@onready var spawneador: Timer = %Spawneador
@onready var aguja: Node2D = %Aguja
@onready var sprite_2d: Sprite2D = %Sprite2D

signal llegó(índice_sílaba: int, precisión: PuzzlePararLaOreja.Precisiones)
@export var cantidad_de_sílabas: int
@export var curva_spawn: Curve

@export var autocentrar: bool = false

var índice_sílaba: int
var eje_input: float
var ángulo_input: float

var _colores: Dictionary[PuzzlePararLaOreja.Precisiones, Color]
var _puntito_actual: PuntitoInterfazSilabeador

func _draw() -> void:
	#draw_circle(Vector2.ZERO, 200, Color(0.0, 0.0, 0.0, 0.486))
	if not _colores:
		return
	draw_arc(Vector2.ZERO, 50, -PI*7/8, -PI/8, 20, _colores[PuzzlePararLaOreja.Precisiones.MAAL], 5)
	draw_arc(Vector2.ZERO, 50,
		clampf(ángulo_input - PI/2 - PI/4, -PI*7/8, -PI/8),
		clampf(ángulo_input - PI/2 + PI/4, -PI*7/8, -PI/8),
		20, _colores[PuzzlePararLaOreja.Precisiones.MASO]
	, 5)
	draw_arc(Vector2.ZERO, 50,
		clampf(ángulo_input - PI/2 - PI/8, -PI*7/8, -PI/8),
		clampf(ángulo_input - PI/2 + PI/8, -PI*7/8, -PI/8),
		20, _colores[PuzzlePararLaOreja.Precisiones.BIEN]
	, 5)

func _input(_event: InputEvent) -> void:
	eje_input = Input.get_axis("move_left", "move_right")

func _physics_process(delta: float) -> void:
	ángulo_input = clampf(ángulo_input + eje_input * 1 * delta, -PI*3/8, PI*3/8)
	aguja.rotation = ángulo_input
	queue_redraw()

func iniciar(colores: Dictionary[PuzzlePararLaOreja.Precisiones, Color]) -> void:
	_colores = colores
	sprite_2d.modulate = _colores[PuzzlePararLaOreja.Precisiones.BIEN]
	queue_redraw()
	índice_sílaba = 0
	spawneador.start()

func _on_spawneador_timeout() -> void:
	if índice_sílaba + 1 > cantidad_de_sílabas:
		return
	var p: PuntitoInterfazSilabeador = PUNTITO.instantiate()
	p.altura_inicial = 200
	p.índice_sílaba = índice_sílaba
	# Debug:
	# var posición := randf_range(-1, 1)
	var s := (índice_sílaba + 1) / float(cantidad_de_sílabas)
	var posición := curva_spawn.sample(s) * 2 - 1

	# La rotación va desde -PI*3/8 a PI*3/8:
	p.rotate(posición * PI*3/8)
	add_child(p)
	if índice_sílaba + 1 == cantidad_de_sílabas:
		spawneador.stop()
	else:
		índice_sílaba += 1


func _on_centro_body_entered(body: Node2D) -> void:
	var puntito := body.owner as PuntitoInterfazSilabeador
	if not puntito:
		return
	var p: PuzzlePararLaOreja.Precisiones
	var diferencia: float = abs(aguja.rotation - puntito.rotation)
	if diferencia <= PI/8:
		p = PuzzlePararLaOreja.Precisiones.BIEN
	elif diferencia <= PI/4:
		p = PuzzlePararLaOreja.Precisiones.MASO
	else:
		p = PuzzlePararLaOreja.Precisiones.MAAL
	# Debug: prioridades random:
	# var p := PuzzlePararLaOreja.Precisiones.values().pick_random() as PuzzlePararLaOreja.Precisiones
	# Debug: prioridades bien o maso random:
	# var p := [PuzzlePararLaOreja.Precisiones.BIEN, PuzzlePararLaOreja.Precisiones.MASO].pick_random() as PuzzlePararLaOreja.Precisiones
	_puntito_actual = puntito
	llegó.emit(puntito.índice_sílaba, p)


func mostrar_sílaba(texto: String, color: Color) -> void:
	_puntito_actual.transformar_en_sílaba(texto, color)

func _ready() -> void:
	if autocentrar:
		center_in_viewport()
		get_tree().root.size_changed.connect(center_in_viewport)

func center_in_viewport() -> void:
	global_position = get_viewport_rect().size / 2
