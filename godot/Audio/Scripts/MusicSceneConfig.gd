extends Resource
class_name MusicSceneConfig
## Configuracion de musica para UNA escena/nivel.
##
## Melodia y Tension usan streams simples (.ogg).
## Bombo y Acompañamiento usan AudioStreamInteractive (.tres), el recurso
## que contiene las 3 variantes + la Transition Matrix configurada en el
## editor (ver instrucciones del AudioManager.gd).
##
## Como usar:
## 1. Click derecho en el panel FileSystem > Nuevo Recurso > buscar
##    "MusicSceneConfig" > guardarlo como, por ejemplo,
##    res://audio/config/nivel1.tres
## 2. Completar los campos en el Inspector.
## 3. Repetir para cada nivel/escena (nivel2.tres, jefe.tres, etc.)

## Musica base, no cambia nunca durante esta escena.
@export var melodia: AudioStream

## Capa que se prende/apaga segun deteccion del jugador.
@export var tension: AudioStream

## Recurso AudioStreamInteractive con las 3 variantes de bombo
## y su Transition Matrix ya configurada.
@export var bombo: AudioStreamInteractive

## Nombres de los clips dentro de "bombo", en orden de intensidad
## creciente. Deben coincidir EXACTO con los nombres puestos en el
## AudioStreamInteractive (ej: "intensidad_0", "intensidad_1", "intensidad_2").
@export var bombo_clip_names: Array[StringName] = []

## Recurso AudioStreamInteractive con las 3 variantes de acompañamiento.
@export var acompanamiento: AudioStreamInteractive

## Nombres de los clips dentro de "acompanamiento", mismo orden que bombo.
@export var acompanamiento_clip_names: Array[StringName] = []

## Tiempo de fade por defecto para esta escena (aplica a Melodia/Tension,
## que no usan Transition Matrix nativa).
@export var fade_time: float = 1.5

## Indice (dentro de bombo_clip_names / acompanamiento_clip_names) de la
## variante con la que arranca esta escena. 0 = primera de la lista.
@export var intensidad_inicial: int = 0
