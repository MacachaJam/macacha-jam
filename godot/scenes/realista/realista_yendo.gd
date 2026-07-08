extends Node

@onready var realista: Realista = $".."
@onready var agent: NavigationAgent3D = %NavigationAgent3D
@onready var detecta_jugadora: Area3D = %DetectaJugadora
@onready var atrapa_jugadora: Area3D = %AtrapaJugadora
@onready var signo_alerta: GPUParticles3D = %"Signo Alerta"


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_ENABLED:
			atrapa_jugadora.set_deferred("monitoring", true)
			atrapa_jugadora.set_deferred("monitorable", true)
			detecta_jugadora.set_deferred("monitoring", true)
			detecta_jugadora.set_deferred("monitorable", true)
			agent.target_reached.connect(_on_target_reached)
			agent.navigation_finished.connect(_on_navigation_finished)
			signo_alerta.emitting = true
			_actualizar_target()
		NOTIFICATION_DISABLED:
			if agent.target_reached.is_connected(_on_target_reached):
				agent.target_reached.disconnect(_on_target_reached)
			if agent.navigation_finished.is_connected(_on_navigation_finished):
				agent.navigation_finished.disconnect(_on_navigation_finished)


func _actualizar_target() -> void:
	var player: Node3D = get_tree().get_first_node_in_group("player")
	agent.target_position = player.global_position
	

func _physics_process(delta: float) -> void:
	if agent.is_navigation_finished():
		realista.velocity.x = move_toward(realista.velocity.x, 0, realista.velocidad_detenerse * delta)
		realista.velocity.z = move_toward(realista.velocity.z, 0, realista.velocidad_detenerse * delta)
	else:
		var d := agent.get_next_path_position()
		var dl := d - realista.global_position
		var direction := dl.normalized()

		if direction:
			realista.velocity.x = direction.x * realista.velocidad_correr * delta
			realista.velocity.z = direction.z * realista.velocidad_correr * delta
		else:
			realista.velocity.x = move_toward(realista.velocity.x, 0, realista.velocidad_correr * delta)
			realista.velocity.z = move_toward(realista.velocity.z, 0, realista.velocidad_correr * delta)

	realista.move_and_slide()

func _on_target_reached() -> void:
	realista.modo = Realista.Modos.BUSCANDO

func _on_navigation_finished() -> void:
	realista.modo = Realista.Modos.BUSCANDO
