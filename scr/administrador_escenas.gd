@icon("res://IconGodotNode/IconGodotNode/color/icon_map_2.png")
extends Node2D

@onready var anim : AnimationPlayer = $TransicionPantalla/AnimationPlayer
@onready var EscenaAtual = $EscenaActual

var Siguiente_escena = null

var player_location: Vector2 = Vector2(0, 0)
var player_direccion: Vector2 = Vector2(0, 0)

enum Tranciciontype {NUEVA_ESCENA, PARTY_SCREEN, SOLO_MENU}
var tipo_trancicion = Tranciciontype.NUEVA_ESCENA

func _ready() -> void:
	anim.play("Quitar")

func trancicion_partysceen():
	anim.play("Colocar")
	tipo_trancicion = Tranciciontype.PARTY_SCREEN

func trancicion_salir_partysceen():
	anim.play("Colocar")
	tipo_trancicion = Tranciciontype.SOLO_MENU

func Trancicion_Escena(nueva_escena: String, spawn_location, spawn_direccion):
	Siguiente_escena = nueva_escena
	player_location = spawn_location
	player_direccion = spawn_direccion
	tipo_trancicion = Tranciciontype.NUEVA_ESCENA
	anim.play("Colocar")
	print("Hola")
	
func terminar_transicion():
	match tipo_trancicion:
		Tranciciontype.NUEVA_ESCENA:
			EscenaAtual.get_child(0).queue_free()
			EscenaAtual.add_child(load(Siguiente_escena).instantiate())
			
			var player = Utils.get_Player()
			player.set_spawn(player_location, player_direccion)
		
		Tranciciontype.PARTY_SCREEN:
			$Menu.cargar_partysceen()
	
		Tranciciontype.SOLO_MENU:
			$Menu.quitar_partysceen()
	anim.play("Quitar")
