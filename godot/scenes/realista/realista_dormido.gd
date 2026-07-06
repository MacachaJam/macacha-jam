extends Node

@onready var realista: Realista = $".."
@onready var detecta_jugadora: Area3D = %DetectaJugadora
@onready var atrapa_jugadora: Area3D = %AtrapaJugadora

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_ENABLED:
			atrapa_jugadora.monitoring = false
			atrapa_jugadora.monitorable = false
			detecta_jugadora.monitoring = false
			detecta_jugadora.monitorable = false
		NOTIFICATION_DISABLED:
			atrapa_jugadora.monitoring = true
			atrapa_jugadora.monitorable = true
			detecta_jugadora.monitoring = true
			detecta_jugadora.monitorable = true

func _physics_process(delta: float) -> void:
	realista.velocity.x = move_toward(realista.velocity.x, 0, realista.velocidad_detenerse * delta)
	realista.velocity.z = move_toward(realista.velocity.z, 0, realista.velocidad_detenerse * delta)
	realista.move_and_slide()
