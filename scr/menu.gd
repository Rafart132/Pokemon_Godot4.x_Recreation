extends CanvasLayer

const PokemonPartyScreen = preload("res://Escenas/party_sceen.tscn")

@onready var Flecha_seleccion:TextureRect = $Control/NinePatchRect/TextureRect
@onready var Menu: Control =  $Control/NinePatchRect
@onready var opciones = $Control/NinePatchRect/VBoxContainer.get_child_count() 
enum ScreenLoader { NOTHING, MENU, PARTY }
var screen_loader = ScreenLoader.NOTHING

enum Opciones { POKEMON, MOCHILA, JUGADOR, GUARDAR, OPCIONES, SALIR}
var selected_option: int = Opciones.POKEMON

@onready var options: Dictionary = {
	Opciones.POKEMON : $Control/NinePatchRect/VBoxContainer/Pokemon, 
	Opciones.MOCHILA : $Control/NinePatchRect/VBoxContainer/Mochila,
	Opciones.JUGADOR : $Control/NinePatchRect/VBoxContainer/Jugador,
	Opciones.GUARDAR : $Control/NinePatchRect/VBoxContainer/Guardar,
	Opciones.OPCIONES : $Control/NinePatchRect/VBoxContainer/Opciones,
	Opciones.SALIR : $Control/NinePatchRect/VBoxContainer/Salir
}


func _ready() -> void:
	Menu.hide()
	Flecha_seleccion.position.y = 6 + (selected_option % opciones) * 15

func  _process(_delta: float) -> void:
	print(selected_option)
	pass
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
				if selected_option == opciones - 1:
					selected_option = 0
				else:
					selected_option += 1
				Flecha_seleccion.position.y = 5 + (selected_option % opciones) * 15
			elif event.is_action_pressed("move_up"):
				if selected_option == 0:
					selected_option = 5
				else:
					selected_option -= 1
				Flecha_seleccion.position.y = 5 + (selected_option % opciones) * 15
			elif event.is_action_pressed("A"):
				match selected_option:
					Opciones.POKEMON:
						Utils.get_administrador_escenas().trancicion_partysceen()
					Opciones.SALIR:
						var player = Utils.get_Player()
						player.set_physics_process(true)
						Menu.hide()
						screen_loader = ScreenLoader.NOTHING
		
		ScreenLoader.PARTY:
			pass
