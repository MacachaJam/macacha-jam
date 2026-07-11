extends Node
## MusicController - Autoload que decide QUE musica suena segun la escena
## actual, y reacciona a triggers del gameplay (deteccion, intensidad).
##
## Es Autoload (igual que AudioManager) => NUNCA se destruye al cambiar
## de escena, la musica sigue viva de forma continua. Al detectar una
## escena nueva, CARGA su configuracion y solo toca las capas cuyo
## audio realmente cambia; las que se repiten entre escenas (ej. la
## misma Melodia) siguen sonando sin cortes ni reinicios.
##
## No modifica nada del codigo del programador: se entera de los cambios
## de escena solo (via node_added) y se conecta a triggers buscando
## nodos por GRUPO, no por ruta fija.

const CAPA_MELODIA := 0
const CAPA_TENSION := 1
const CAPA_BOMBO := 2
const CAPA_ACOMPANAMIENTO := 3

const ARBOL = preload("uid://c0ld57hm5waqf")
const CAMPAMENTO = preload("uid://cvt8cc4a7fhmu")
const CENTRO = preload("uid://cejg3h3qhba75")
const SALON = preload("uid://17qwjd6y140s")
const BARRACAS = preload("uid://pv2qijv8mdi6")


## Mapeo: ruta de la escena (.tscn) -> ruta del recurso de configuracion (.tres)
const CONFIGS := {
	"res://scenes/Levels/Arbol.tscn": ARBOL,
	"res://scenes/Levels/Campamento.tscn": CAMPAMENTO,
	"res://scenes/Levels/Centro.tscn": CENTRO,
	"res://scenes/Levels/Salon.tscn": SALON,
	"res://scenes/Levels/Barracas.tscn": BARRACAS,
}

var config: MusicSceneConfig
var _intensidad_actual := -1

## Used to resolve the current scene. Override if your game manages the current scene itself.
var get_current_scene: Callable = func():
	var current_scene: Node = Engine.get_main_loop().current_scene
	if current_scene == null:
		current_scene = Engine.get_main_loop().root.get_child(Engine.get_main_loop().root.get_child_count() - 1)
	return current_scene

func _ready() -> void:
	get_tree().scene_changed.connect(_on_scene_changed)
	_on_scene_changed()

func _on_scene_changed() -> void:
	var node: Node = get_current_scene.call()
	_cargar_escena(node)

func _cargar_escena(scene_root: Node) -> void:
	var path := scene_root.scene_file_path

	if not CONFIGS.has(path):
		AudioManager.solo_layers([])
		return # esta escena no tiene musica configurada

	if not GameState.global.hechos_del_dia.get("te_descubrieron"):
		AudioManager.unsolo_layers([CAPA_TENSION])
	else:
		AudioManager.unsolo_all()
	var nueva_config: MusicSceneConfig = CONFIGS[path]

	# Si es la MISMA config que ya estaba sonando (volviste a la misma
	# escena), no tocamos nada, la musica sigue viva tal cual.
	if nueva_config == config:
		return

	config = nueva_config
	var nivel_inicial: int = config.intensidad_inicial

	# --- Melodia ---
	# Si el audio de melodia es EXACTAMENTE el mismo que ya estaba sonando
	# (comparten el mismo .ogg entre escenas), no la reiniciamos: sigue
	# sonando desde donde iba, sin corte al cruzar la puerta.
	if config.melodia and not AudioManager.is_layer_stream(CAPA_MELODIA, config.melodia):
		AudioManager.play_layer(CAPA_MELODIA, config.melodia, &"", config.fade_time)

	# --- Tension ---
	# Mismo criterio. Si cambia el audio de tension, se vuelve a arrancar
	# en silencio (en fase con lo nuevo). Si es el mismo, sigue igual.
	if config.tension and not AudioManager.is_layer_stream(CAPA_TENSION, config.tension):
		AudioManager.play_layer_silent(CAPA_TENSION, config.tension)

	# --- Bombo ---
	# Si el AudioStreamInteractive es el MISMO recurso que ya estaba
	# sonando en esta capa, no reiniciamos el player (no perdemos el
	# compas): solo pedimos el cambio de variante con switch_layer_clip.
	# Si es un recurso distinto (otro set de variantes), arranca de cero.
	if config.bombo and config.bombo_clip_names.size() > nivel_inicial:
		var clip_bombo: StringName = config.bombo_clip_names[nivel_inicial]
		if AudioManager.is_layer_stream(CAPA_BOMBO, config.bombo):
			AudioManager.switch_layer_clip(CAPA_BOMBO, clip_bombo)
		else:
			AudioManager.play_layer(CAPA_BOMBO, config.bombo, clip_bombo, config.fade_time)

	# --- Acompañamiento ---
	if config.acompanamiento and config.acompanamiento_clip_names.size() > nivel_inicial:
		var clip_acomp: StringName = config.acompanamiento_clip_names[nivel_inicial]
		if AudioManager.is_layer_stream(CAPA_ACOMPANAMIENTO, config.acompanamiento):
			AudioManager.switch_layer_clip(CAPA_ACOMPANAMIENTO, clip_acomp)
		else:
			AudioManager.play_layer(CAPA_ACOMPANAMIENTO, config.acompanamiento, clip_acomp, config.fade_time)

	_intensidad_actual = nivel_inicial
	_conectar_triggers()


## Cambia de variante de Bombo/Acompañamiento usando la Transition Matrix
## nativa (sincronizada al compas), no un Tween manual.
## nivel = indice dentro de bombo_clip_names / acompanamiento_clip_names.
func cambiar_intensidad(nivel: int) -> void:
	if config == null:
		return

	var max_nivel := config.bombo_clip_names.size() - 1
	nivel = clamp(nivel, 0, max_nivel)
	if nivel == _intensidad_actual:
		return
	_intensidad_actual = nivel

	if nivel < config.bombo_clip_names.size():
		AudioManager.switch_layer_clip(CAPA_BOMBO, config.bombo_clip_names[nivel])
	if nivel < config.acompanamiento_clip_names.size():
		AudioManager.switch_layer_clip(CAPA_ACOMPANAMIENTO, config.acompanamiento_clip_names[nivel])


func activar_tension() -> void:
	if config and config.tension:
		AudioManager.unmute_layer(CAPA_TENSION, 1.0)


func desactivar_tension() -> void:
	AudioManager.mute_layer(CAPA_TENSION, 0.3)


func _conectar_triggers() -> void:
	GameState.scene.jugadora_descubierta.connect(activar_tension)
