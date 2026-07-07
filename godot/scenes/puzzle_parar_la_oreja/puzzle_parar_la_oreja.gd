class_name PuzzlePararLaOreja
extends Node

enum Precisiones { BIEN, MASO, MAAL }

signal fin_del_puzzle(éxito: bool)

@export var frase := "Resulta que la Juana está engatuzando al coronel, y el idiota le contó que van a atacar con ocho cañones por el flanco norte."

@export var silabeos: Dictionary[Precisiones, String] = {
	Precisiones.BIEN: "re-[b]sul[/b]-ta-que-la-[b]jua[/b]-naes-[b]táen[/b]-ga-tu-[b]zan[/b]-doal-co-ro-[b]nel[/b]-yel-i-[b]dio[/b]-ta-le-con-[b]tó[/b]-que-[b]van[/b]-aa-ta-[b]car[/b]-con-[b]o[/b]-cho-ca-[b]ño[/b]-nes-por-el-[b]flan[/b]-co-[b]nor[/b]-te",
	Precisiones.MASO: "reeh-[b]zul[/b]-tah-ke-laa-[b]gua[/b]-mees-[b]táem[/b]-ja-tuh-[b]sam[/b]-dal-po-no-[b]rel[/b]-miel-y-[b]dó[/b]-tah-lle-com-[b]pó[/b]-ke-[b]bam[/b]-ea-ca-[b]tar[/b]-pon-[b]ho[/b]-cho-ta-[b]mio[/b]-nez-cor-ell-[b]cran[/b]-fo-[b]mor[/b]-teh",
	Precisiones.MAAL: "hm-[b]mmm[/b]-hm-mmm-hm-[b]mmm[/b]-hhmm-[b]hmmm[/b]-hm-mm-[b]hmm[/b]-mmmm-hm-hm-[b]mmm[/b]-hmm-h-[b]mmm[/b]-mm-hm-hmm-[b]mm[/b]-hmm-[b]mmm[/b]-hm-mm-[b]hmm[/b]-hmm-[b]h[/b]-hmm-mm-[b]mm[/b]-hmm-hmm-mm-[b]hhmm[/b]-mm-[b]mmm[/b]-mm",
}

@export var puntos_x_precisión: Dictionary[Precisiones, float] = {
	Precisiones.BIEN: 1,
	Precisiones.MASO: 0.8,
	Precisiones.MAAL: -1,
}

@export var colores_x_precisión: Dictionary[Precisiones, Color] = {
	Precisiones.BIEN: Color(0.568, 0.947, 0.355, 1.0),
	Precisiones.MASO: Color(0.976, 0.918, 0.0, 1.0),
	Precisiones.MAAL: Color(1.0, 0.505, 0.487, 1.0),
}

@export var diálogo: DiálogoSilabeador
@export var interfaz: InterfazSilabeador


var lista_sílabas: Dictionary[Precisiones, Array]
var cantidad_de_sílabas: int


var _puntaje: float

func _ready() -> void:
	lista_sílabas = {
		Precisiones.BIEN: Array(silabeos[Precisiones.BIEN].split("-")),
		Precisiones.MASO: Array(silabeos[Precisiones.MASO].split("-")),
		Precisiones.MAAL: Array(silabeos[Precisiones.MAAL].split("-")),
	}
	cantidad_de_sílabas = lista_sílabas[Precisiones.BIEN].size()
	# prints(cantidad_de_sílabas, lista_sílabas[Precisiones.MASO].size(), lista_sílabas[Precisiones.MAAL].size())
	assert(lista_sílabas[Precisiones.MASO].size() == cantidad_de_sílabas)
	assert(lista_sílabas[Precisiones.MAAL].size() == cantidad_de_sílabas)

func iniciar() -> void:
	interfaz.cantidad_de_sílabas = cantidad_de_sílabas
	interfaz.visible = true
	if not diálogo.is_node_ready():
		diálogo.ready.connect(_on_diálogo_ready, CONNECT_ONE_SHOT)
	else:
		_on_diálogo_ready()


func _on_diálogo_ready() -> void:
	await diálogo.iniciar()
	_puntaje = 0
	interfaz.llegó.connect(_on_interfaz_llegó)
	interfaz.iniciar(colores_x_precisión)

func _on_interfaz_llegó(índice_sílaba: int, precisión: Precisiones) -> void:
	_puntaje += puntos_x_precisión[precisión]
	var s := lista_sílabas[precisión][índice_sílaba] as String
	var última := índice_sílaba == lista_sílabas[Precisiones.BIEN].size() - 1
	var color := colores_x_precisión[precisión]
	interfaz.mostrar_sílaba(s, color)
	diálogo.agregar_sílaba(s, color, última)
	if última:
		var porcentaje_puntos := _puntaje / cantidad_de_sílabas * 100
		await get_tree().create_timer(0.5).timeout
		if porcentaje_puntos >= 80:
			await diálogo.revelar_frase(frase)
			_terminar(true)
		else:
			await diálogo.no_entendí()
			_terminar(false)

func _terminar(éxito: bool) -> void:
	interfaz.visible = false
	interfaz.llegó.disconnect(_on_interfaz_llegó)
	fin_del_puzzle.emit(éxito)
