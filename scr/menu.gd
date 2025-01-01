extends CanvasLayer

const PokemonPartyScreen = preload("res://Escenas/party_sceen.tscn")

@onready var Flecha_seleccion:TextureRect = $Control/NinePatchRect/TextureRect
@onready var Menu: Control =  $Control/NinePatchRect
@onready var opciones = $Control/NinePatchRect/VBoxContainer.get_child_count()
enum ScreenLoader { NOTHING, MENU, PARTY }
var screen_loader = ScreenLoader.NOTHING

var seleccionar_opcion: int = 0


func _ready() -> void:
	Menu.hide()
	Flecha_seleccion.position.y = 6 + (seleccionar_opcion % opciones) * 15

func cargar_partysceen():
	Menu.hide()
	screen_loader = ScreenLoader.PARTY
	var PPS = PokemonPartyScreen.instantiate()
	add_child(PPS)

func quitar_partysceen():
	Menu.show()
	screen_loader = ScreenLoader.MENU
	remove_child($PartySceen)

func _unhandled_input(event: InputEvent) -> void:
	match screen_loader:
		ScreenLoader.NOTHING:
			if event.is_action_pressed("Pause"):
				var player = Utils.get_Player()
				if !player.is_moving:
					player.set_physics_process(false)
					Menu.show()
					screen_loader = ScreenLoader.MENU

		ScreenLoader.MENU:
			if event.is_action_pressed("B"):
				var player = Utils.get_Player()
				player.set_physics_process(true)
				Menu.hide()
				screen_loader = ScreenLoader.NOTHING
			elif event.is_action_pressed("move_down"):
				seleccionar_opcion += 1
				Flecha_seleccion.position.y = 6 + (seleccionar_opcion % opciones) * 15
			elif event.is_action_pressed("move_up"):
				if seleccionar_opcion == 0:
					seleccionar_opcion = 6
				else:
					seleccionar_opcion -= 1
				Flecha_seleccion.position.y = 6 + (seleccionar_opcion % opciones) * 15
			elif event.is_action_pressed("A"):
				Utils.get_administrador_escenas().trancicion_partysceen()
		
		ScreenLoader.PARTY:
			pass
