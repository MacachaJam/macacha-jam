extends Area3D

var _area: Area3D

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)

func _unhandled_input(event: InputEvent) -> void:
	if not _area or not event.is_action_pressed("interact"):
		return
	if _area.has_signal("fin_interactuar"):
		var jugadora: Jugadora = get_tree().get_first_node_in_group("player") as Jugadora
		if jugadora:
			jugadora.cambiar_detenida(true)
		_area.connect("fin_interactuar", _on_fin_interactuar)
	_area.call("interactuar")

func _on_area_entered(area: Area3D) -> void:
	if not area.has_method("interactuar"):
		return
	# TODO: poner flechita
	prints("poner flechita")
	_area = area
	pass
	#if mostrando_diálogo:
		#return
	#var nodo := DialogueManager.show_dialogue_balloon(diálogo)
	#mostrando_diálogo = true
	#nodo.tree_exited.connect(_on_fin_diálogo)

func _on_area_exited(area: Area3D) -> void:
	if not area.has_method("interactuar"):
		return
	if area == _area:
		_area = null
	# TODO: sacar flechita
	prints("sacar flechita")
	pass

func _on_fin_interactuar() -> void:
	prints(_on_fin_interactuar)
	var jugadora: Jugadora = get_tree().get_first_node_in_group("player") as Jugadora
	if jugadora:
		jugadora.cambiar_detenida(false)
