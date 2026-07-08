class_name ControlesPantalla
extends Node

@onready var boton_touch_izquierda: TouchScreenButton = %BotonTouchIzquierda
@onready var boton_touch_derecha: TouchScreenButton = %BotonTouchDerecha
@onready var boton_touch_interactuar: TouchScreenButton = %BotonTouchInteractuar

func _ready() -> void:
	cambiar_izq_der(false)
	cambiar_interactuar(false)

func cambiar_izq_der(activar: bool = true) -> void:
	boton_touch_izquierda.process_mode = Node.PROCESS_MODE_INHERIT if activar else Node.PROCESS_MODE_DISABLED
	boton_touch_derecha.process_mode = Node.PROCESS_MODE_INHERIT if activar else Node.PROCESS_MODE_DISABLED
	boton_touch_izquierda.visible = activar
	boton_touch_derecha.visible = activar

func cambiar_interactuar(activar: bool = true) -> void:
	boton_touch_interactuar.process_mode = Node.PROCESS_MODE_INHERIT if activar else Node.PROCESS_MODE_DISABLED
	boton_touch_interactuar.visible = activar
