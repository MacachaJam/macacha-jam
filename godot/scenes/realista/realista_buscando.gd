extends Node

@onready var realista: Realista = $".."
@onready var agent: NavigationAgent3D = %NavigationAgent3D
@onready var detecta_jugadora: Area3D = %DetectaJugadora
@onready var atrapa_jugadora: Area3D = %AtrapaJugadora

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_ENABLED:
			atrapa_jugadora.set_deferred("monitoring", true)
			atrapa_jugadora.set_deferred("monitorable", true)
			detecta_jugadora.set_deferred("monitoring", true)
			detecta_jugadora.set_deferred("monitorable", true)
			agent.target_reached.connect(_on_target_reached)
			agent.navigation_finished.connect(_on_navigation_finished)
			_actualizar_target()
		NOTIFICATION_DISABLED:
			agent.target_reached.disconnect(_on_target_reached)
			agent.navigation_finished.disconnect(_on_navigation_finished)

func _actualizar_target() -> void:
	if realista.velocity:
		var a := randf_range(-PI, PI)
		var d := realista.velocity.normalized().rotated(Vector3.UP, a) * (1 + 3 * randf())
		agent.target_position = realista.global_position + d
	else:
		var a := randf_range(0, 2 * PI)
		var d := Vector3.RIGHT.rotated(Vector3.UP, a) * (1 + 3 * randf())
		agent.target_position = realista.global_position + d
	

func _physics_process(delta: float) -> void:
	if agent.is_navigation_finished():
		realista.velocity.x = move_toward(realista.velocity.x, 0, realista.velocidad_detenerse * delta)
		realista.velocity.z = move_toward(realista.velocity.z, 0, realista.velocidad_detenerse * delta)
	else:
		var d := agent.get_next_path_position()
		var dl := d - realista.global_position
		var direction := dl.normalized()

		if direction:
			realista.velocity.x = direction.x * realista.velocidad_buscar * delta
			realista.velocity.z = direction.z * realista.velocidad_buscar * delta
		else:
			realista.velocity.x = move_toward(realista.velocity.x, 0, realista.velocidad_buscar * delta)
			realista.velocity.z = move_toward(realista.velocity.z, 0, realista.velocidad_buscar * delta)

	realista.move_and_slide()

func _on_target_reached() -> void:
	_actualizar_target()

func _on_navigation_finished() -> void:
	_actualizar_target()
