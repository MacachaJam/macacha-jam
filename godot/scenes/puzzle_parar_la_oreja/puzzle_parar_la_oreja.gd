class_name PuzzlePararLaOreja
extends Node

@export var diálogo: DiálogoSilabeador
@export var interfaz: InterfazSilabeador

enum Precisiones { BIEN, MASO, MAAL }

var frase := "Resulta que la Juana está engatuzando al coronel, y el idiota le contó que van a atacar con ocho cañones por el flanco norte."

var silabeos := {
	Precisiones.BIEN: "re-[b]sul[/b]-ta-que-la-[b]jua[/b]-naes-[b]táen[/b]-ga-tu-[b]zan[/b]-doal-co-ro-[b]nel[/b]-yel-i-[b]dio[/b]-ta-le-con-[b]tó[/b]-que-[b]van[/b]-aa-ta-[b]car[/b]-con-[b]o[/b]-cho-ca-[b]ño[/b]-nes-por-el-[b]flan[/b]-co-[b]nor[/b]-te",
	Precisiones.MASO: "reeh-[b]zul[/b]-tah-ke-laa-[b]gua[/b]-mees-[b]táem[/b]-ja-tuh-[b]sam[/b]-dal-po-no-[b]rel[/b]-miel-y-[b]dó[/b]-tah-lle-com-[b]pó[/b]-ke-[b]bam[/b]-ea-ca-[b]tar[/b]-pon-[b]ho[/b]-cho-ta-[b]mio[/b]-nez-cor-ell-[b]cran[/b]-fo-[b]mor[/b]-teh",
	Precisiones.MAAL: "hm-[b]mmm[/b]-hm-mmm-hm-[b]mmm[/b]-hhmm-[b]hmmm[/b]-hm-mm-[b]hmm[/b]-mmmm-hm-hm-[b]mmm[/b]-hmm-h-[b]mmm[/b]-mm-hm-hmm-[b]mm[/b]-hmm-[b]mmm[/b]-hm-mm-[b]hmm[/b]-hmm-[b]h[/b]-hmm-mm-[b]mm[/b]-hmm-hmm-mm-[b]hhmm[/b]-mm-[b]mmm[/b]-mm",
}

var lista_sílabas: Dictionary[Precisiones, Array] = {
	Precisiones.BIEN: Array(silabeos[Precisiones.BIEN].split("-")),
	Precisiones.MASO: Array(silabeos[Precisiones.MASO].split("-")),
	Precisiones.MAAL: Array(silabeos[Precisiones.MAAL].split("-")),
}

var cantidad_de_sílabas := lista_sílabas[Precisiones.BIEN].size()

var puntos_x_presición: Dictionary[Precisiones, float] = {
	Precisiones.BIEN: 1,
	Precisiones.MASO: 0.8,
	Precisiones.MAAL: 0,
}

var puntaje: float


func _ready() -> void:
	assert(lista_sílabas[Precisiones.MASO].size() == cantidad_de_sílabas)
	assert(lista_sílabas[Precisiones.MAAL].size() == cantidad_de_sílabas)

	interfaz.cantidad_de_sílabas = cantidad_de_sílabas

	if not diálogo.is_node_ready():
		diálogo.ready.connect(_on_diálogo_ready)
	else:
		_on_diálogo_ready()


func _on_diálogo_ready() -> void:
	await diálogo.iniciar()
	puntaje = 0
	interfaz.llegó.connect(_on_interfaz_llegó)
	interfaz.iniciar()

func _on_interfaz_llegó(índice_sílaba: int, precisión: Precisiones) -> void:
	puntaje += puntos_x_presición[precisión]
	var s := lista_sílabas[precisión][índice_sílaba] as String
	var última := índice_sílaba == lista_sílabas[Precisiones.BIEN].size() - 1
	diálogo.agregar_sílaba(s, precisión, última)
	if última:
		var porcentaje_puntos := puntaje / cantidad_de_sílabas * 100
		await get_tree().create_timer(0.5).timeout
		if porcentaje_puntos >= 80:
			diálogo.revelar_frase(frase)
		else:
			diálogo.no_entendí()
