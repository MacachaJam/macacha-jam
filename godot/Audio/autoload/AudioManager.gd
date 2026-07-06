extends Node
## AudioManager - Singleton (Autoload) para manejar musica por capas.
##
## Basado en la charla "Beyond the Loop" (GodotFest) de Paul (251 Studio):
## usa los nodos nativos de audio interactivo introducidos en Godot 4.3
## en vez de fades hechos a mano con Tween. Esto permite transiciones
## sincronizadas al beat/compas, definidas visualmente en el Inspector
## (Transition Matrix de AudioStreamInteractive), en vez de a codigo.
##
## Cada capa tiene un AudioStreamPlayer. Su "stream" puede ser:
##  - un AudioStream simple (.ogg) para capas que no cambian de variante
##    (ej: Melodia), o que solo prenden/apagan (ej: Tension).
##  - un AudioStreamInteractive para capas con multiples variantes que
##    necesitan cambiar de una a otra de forma prolija (ej: Bombo,
##    Acompañamiento), aprovechando la Transition Matrix configurada
##    en el editor.
##
## Sigue siendo Autoload: no se destruye al cambiar de escena, la
## musica sigue sonando de forma continua.
##
## Uso tipico:
##   AudioManager.play_layer(CAPA_MELODIA, preload("res://audio/melodia.ogg"))
##   AudioManager.play_layer(CAPA_BOMBO, preload("res://audio/interactive/bombo.tres"), "intensidad_0")
##   AudioManager.switch_layer_clip(CAPA_BOMBO, "intensidad_2")
##   AudioManager.mute_layer(CAPA_TENSION)
##   AudioManager.solo_layer(CAPA_BOMBO)

const NUM_LAYERS := 4
const DEFAULT_FADE := 1.0

var _players: Array[AudioStreamPlayer] = []
var _target_volume_db: Array[float] = []
var _tweens: Array[Tween] = []


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

	for i in NUM_LAYERS:
		var player := AudioStreamPlayer.new()
		player.name = "Layer%d" % i
		player.process_mode = Node.PROCESS_MODE_ALWAYS
		player.volume_db = -80.0
		add_child(player)
		_players.append(player)
		_target_volume_db.append(0.0)
		_tweens.append(null)


func _valid_layer(layer: int) -> bool:
	if layer < 0 or layer >= NUM_LAYERS:
		push_warning("AudioManager: capa invalida (%d). Debe ser 0..%d" % [layer, NUM_LAYERS - 1])
		return false
	return true


func _kill_tween(layer: int) -> void:
	if _tweens[layer] != null and _tweens[layer].is_valid():
		_tweens[layer].kill()
	_tweens[layer] = null


## Reproduce un stream (simple o AudioStreamInteractive) en la capa dada.
## Si es un AudioStreamInteractive y pasas initial_clip, arranca en ese clip.
func play_layer(layer: int, stream: AudioStream, initial_clip: StringName = &"", fade_time: float = DEFAULT_FADE, volume_db: float = 0.0) -> void:
	if not _valid_layer(layer):
		return

	var player := _players[layer]
	_kill_tween(layer)

	player.stream = stream
	player.volume_db = -80.0
	player.play()

	if initial_clip != &"" and stream is AudioStreamInteractive:
		var playback := player.get_stream_playback() as AudioStreamPlaybackInteractive
		if playback:
			playback.switch_to_clip_by_name(initial_clip)

	_target_volume_db[layer] = volume_db
	var tween := create_tween()
	_tweens[layer] = tween
	tween.tween_property(player, "volume_db", volume_db, fade_time)


## Arranca una capa reproduciendo YA MISMO, pero en silencio (-80dB),
## sin ningun fade. Se usa para capas que deben quedar sincronizadas en
## fase con las demas desde el principio (ej: Tension), y que despues
## se activan/desactivan solo con mute_layer/unmute_layer, SIN volver a
## llamar play() nunca -> asi nunca pierden el compas.
func play_layer_silent(layer: int, stream: AudioStream, target_volume_db: float = 0.0) -> void:
	if not _valid_layer(layer):
		return

	var player := _players[layer]
	_kill_tween(layer)

	player.stream = stream
	player.volume_db = -80.0
	player.play()

	_target_volume_db[layer] = target_volume_db


## Cambia de variante DENTRO de la misma capa (requiere que el stream
## de esa capa sea un AudioStreamInteractive con esa Transition Matrix
## configurada en el editor). El fade/sincronizacion al compas lo maneja
## el motor, no hace falta Tween aca.
func switch_layer_clip(layer: int, clip_name: StringName) -> void:
	if not _valid_layer(layer):
		return

	var player := _players[layer]
	if not (player.stream is AudioStreamInteractive):
		push_warning("AudioManager: la capa %d no usa AudioStreamInteractive" % layer)
		return

	var playback := player.get_stream_playback() as AudioStreamPlaybackInteractive
	if playback:
		playback.switch_to_clip_by_name(clip_name)


## Corta la capa indicada con fade out y detiene el player al terminar.
func stop_layer(layer: int, fade_time: float = DEFAULT_FADE) -> void:
	if not _valid_layer(layer):
		return

	var player := _players[layer]
	_kill_tween(layer)

	var tween := create_tween()
	_tweens[layer] = tween
	tween.tween_property(player, "volume_db", -80.0, fade_time)
	tween.tween_callback(player.stop)


## Sube o baja el volumen de una capa que ya esta sonando.
func set_layer_volume(layer: int, volume_db: float, fade_time: float = DEFAULT_FADE) -> void:
	if not _valid_layer(layer):
		return

	_kill_tween(layer)
	_target_volume_db[layer] = volume_db

	var tween := create_tween()
	_tweens[layer] = tween
	tween.tween_property(_players[layer], "volume_db", volume_db, fade_time)


## Corta todas las capas con fade out.
func stop_all(fade_time: float = DEFAULT_FADE) -> void:
	for i in NUM_LAYERS:
		stop_layer(i, fade_time)


## Devuelve true si la capa esta sonando actualmente.
func is_layer_playing(layer: int) -> bool:
	if not _valid_layer(layer):
		return false
	return _players[layer].playing


## Devuelve true si la capa YA esta reproduciendo ese stream/recurso
## exacto (mismo AudioStream o mismo AudioStreamInteractive). Se usa
## para no reiniciar una capa que no cambio al pasar de una escena a
## otra, dejandola continuar desde donde va en vez de cortarla.
func is_layer_stream(layer: int, stream: AudioStream) -> bool:
	if not _valid_layer(layer):
		return false
	return _players[layer].stream == stream


## Silencia una capa SIN detenerla (mantiene su posicion de reproduccion,
## y si es AudioStreamInteractive, mantiene el clip activo).
func mute_layer(layer: int, fade_time: float = DEFAULT_FADE) -> void:
	if not _valid_layer(layer):
		return

	_kill_tween(layer)
	var tween := create_tween()
	_tweens[layer] = tween
	tween.tween_property(_players[layer], "volume_db", -80.0, fade_time)


## Vuelve a subir el volumen de una capa muteada, al volumen previo.
func unmute_layer(layer: int, fade_time: float = DEFAULT_FADE) -> void:
	if not _valid_layer(layer):
		return

	_kill_tween(layer)
	var tween := create_tween()
	_tweens[layer] = tween
	tween.tween_property(_players[layer], "volume_db", _target_volume_db[layer], fade_time)


## Deja sonando SOLO la capa indicada y silencia todas las demas.
func solo_layer(layer: int, fade_time: float = DEFAULT_FADE) -> void:
	if not _valid_layer(layer):
		return

	for i in NUM_LAYERS:
		if i == layer:
			unmute_layer(i, fade_time)
		else:
			mute_layer(i, fade_time)


## Deja sonando SOLO las capas de la lista indicada y silencia el resto.
func solo_layers(layers: Array, fade_time: float = DEFAULT_FADE) -> void:
	for i in NUM_LAYERS:
		if i in layers:
			unmute_layer(i, fade_time)
		else:
			mute_layer(i, fade_time)


## Vuelve a traer todas las capas de golpe (deshace solo_layer/mute_layer).
func unsolo_all(fade_time: float = DEFAULT_FADE) -> void:
	for i in NUM_LAYERS:
		unmute_layer(i, fade_time)
