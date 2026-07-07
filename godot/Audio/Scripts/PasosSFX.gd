@onready var sprite: AnimatedSprite3D = $AnimatedSprite3D
@onready var pasos_sfx: AudioStreamPlayer = $PasosSFX

func _ready() -> void:
	sprite.animation_changed.connect(_on_animation_changed)

func _on_animation_changed() -> void:
	if sprite.animation == "caminando":
		pasos_sfx.play()
	else:
		pasos_sfx.stop()
