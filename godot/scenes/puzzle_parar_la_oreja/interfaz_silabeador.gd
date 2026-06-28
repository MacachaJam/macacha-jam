class_name InterfazSilabeador
extends Node2D

const PUNTITO = preload("uid://bhm2harux28fv")

@onready var spawneador: Timer = %Spawneador
@onready var aguja: Node2D = %Aguja

signal llegó(índice_sílaba: int, precisión: PuzzlePararLaOreja.Precisiones)
@export var cantidad_de_sílabas: int

var índice_sílaba: int
var eje_input: float
var ángulo_input: float

func _draw() -> void:
	draw_circle(Vector2.ZERO, 200, Color(0.0, 0.0, 0.0, 0.486))
	draw_arc(Vector2.ZERO, 50, -PI/8, -PI*7/8, 20, Color.RED, 5)

func _input(_event: InputEvent) -> void:
	eje_input = Input.get_axis("escuchar_izquierda", "escuchar_derecha")

func _physics_process(delta: float) -> void:
	ángulo_input = clampf(ángulo_input + eje_input * 0.05, -PI*3/8, PI*3/8)

func _process(delta: float) -> void:
	aguja.rotation = ángulo_input


func iniciar() -> void:
	índice_sílaba = 0
	spawneador.timeout.connect(_on_spawneador_timeout)
	spawneador.start()

func _on_spawneador_timeout() -> void:
	var p: PuntitoInterfazSilabeador = PUNTITO.instantiate()
	p.altura = 200
	p.índice_sílaba = índice_sílaba
	var posición := randf_range(-1, 1)
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
	if diferencia <= 0.4:
		p = PuzzlePararLaOreja.Precisiones.BIEN
	elif diferencia <= 1.0:
		p = PuzzlePararLaOreja.Precisiones.MASO
	else:
		p = PuzzlePararLaOreja.Precisiones.MAAL
	# Debug: prioridades random:
	# var p := PuzzlePararLaOreja.Precisiones.values().pick_random() as PuzzlePararLaOreja.Precisiones
	# Debug: prioridades bien o maso random:
	# var p := [PuzzlePararLaOreja.Precisiones.BIEN, PuzzlePararLaOreja.Precisiones.MASO].pick_random() as PuzzlePararLaOreja.Precisiones
	llegó.emit(puntito.índice_sílaba, p)
	puntito.queue_free()
