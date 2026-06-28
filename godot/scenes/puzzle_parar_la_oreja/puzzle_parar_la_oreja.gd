extends Node

@export var diálogo: DiálogoSilabeador
@export var interfaz: InterfazSilabeador

var silabeo_bien := "re-[b]sul[/b]-ta-que-la-[b]jua[/b]-naes-[b]táen[/b]-ga-tu-[b]zan[/b]-doal-co-ro-[b]nel[/b]-yel-i-[b]dio[/b]-ta-le-con-[b]tó[/b]-que-[b]van[/b]-aa-ta-[b]car[/b]-con-[b]o[/b]-cho-ca-[b]ño[/b]-nes-por-el-[b]flan[/b]-co-[b]nor[/b]-te"
var silabeo_maso := "re-[b]sul[/b]-ta-que-la-[b]jua[/b]-naes-[b]táen[/b]-ga-tu-[b]zan[/b]-doal-co-ro-[b]nel[/b]-yel-i-[b]dio[/b]-ta-le-con-[b]tó[/b]-que-[b]van[/b]-aa-ta-[b]car[/b]-con-[b]o[/b]-cho-ca-[b]ño[/b]-nes-por-el-[b]flan[/b]-co-[b]nor[/b]-te"
var silabeo_maal := "re-[b]sul[/b]-ta-que-la-[b]jua[/b]-naes-[b]táen[/b]-ga-tu-[b]zan[/b]-doal-co-ro-[b]nel[/b]-yel-i-[b]dio[/b]-ta-le-con-[b]tó[/b]-que-[b]van[/b]-aa-ta-[b]car[/b]-con-[b]o[/b]-cho-ca-[b]ño[/b]-nes-por-el-[b]flan[/b]-co-[b]nor[/b]-te"
var resultado := "Resulta que la Juana está engatuzando al coronel, y el idiota le contó que van a atacar con ocho cañones por el flanco norte."

var lista_sílabas_bien := Array(silabeo_bien.split("-"))
var lista_sílabas_maso := Array(silabeo_maso.split("-"))
var lista_sílabas_maal := Array(silabeo_maal.split("-"))

func _ready() -> void:
	assert(lista_sílabas_bien.size() == lista_sílabas_maso.size())
	assert(lista_sílabas_bien.size() == lista_sílabas_maal.size())

	interfaz.cantidad_de_sílabas = lista_sílabas_bien.size()

	if not diálogo.is_node_ready():
		diálogo.ready.connect(_on_diálogo_ready)
	else:
		_on_diálogo_ready()


func _on_diálogo_ready() -> void:
	await diálogo.iniciar()
	interfaz.llegó.connect(_on_interfaz_llegó)
	interfaz.iniciar()

func _on_interfaz_llegó(índice_sílaba: int) -> void:
	var s := lista_sílabas_bien[índice_sílaba] as String
	var última := índice_sílaba == lista_sílabas_bien.size() - 1
	diálogo.agregar_sílaba(s, última)
	if última:
		await get_tree().create_timer(0.5).timeout
		diálogo.mostrar_resultado(resultado)
