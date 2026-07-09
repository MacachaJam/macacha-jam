extends AudioStreamPlayer

@export var fade_in: bool = true
@export var fade_out: bool = true

var volume_db_inicial: float
var t: Tween

func _ready() -> void:
	volume_db_inicial = volume_db
	if not fade_out:
		return
	Transitions.started.connect(_on_transition_started)
	

func _enter_tree() -> void:
	if not fade_in:
		return
	t = create_tween()
	volume_db = -80
	t.tween_property(self, "volume_db", volume_db_inicial, 1.0)

func _on_transition_started() -> void:
	t = create_tween()
	t.tween_property(self, "volume_db", -80, 1.0)
