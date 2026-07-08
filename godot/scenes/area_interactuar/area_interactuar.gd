extends Area3D

@onready var flechita: Node3D = %Flechita

var _area: Area3D

func _ready() -> void:
	flechita.visible = false
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)

func _unhandled_input(event: InputEvent) -> void:
	if not _area or not event.is_action_pressed("interact"):
		return
	if _area.has_signal("fin_interactuar"):
		var jugadora: Jugadora = get_tree().get_first_node_in_group("player") as Jugadora
		if jugadora:
			jugadora.cambiar_detenida(true)
		_area.connect("fin_interactuar", _on_fin_interactuar, CONNECT_ONE_SHOT)
	flechita.visible = false
	_area.call("interactuar")

func _on_area_entered(area: Area3D) -> void:
	if not area.has_method("interactuar"):
		return
	flechita.visible = true
	flechita.global_position = area.global_position
	_area = area

func _on_area_exited(area: Area3D) -> void:
	if not area.has_method("interactuar"):
		return
	if area == _area:
		_area = null
	flechita.visible = false

func _on_fin_interactuar(desactivada: bool) -> void:
	var jugadora: Jugadora = get_tree().get_first_node_in_group("player") as Jugadora
	if jugadora:
		jugadora.cambiar_detenida(false)
	if desactivada:
		_area = null
