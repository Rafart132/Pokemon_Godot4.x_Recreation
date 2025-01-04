extends Node2D

enum Options { PRIMER_SLOT, SEGUNDO_SLOT, TERCER_SLOT, CUARTO_SLOT, QUINTO_SLOT, SEXTO_SLOT, CANCEL }
var selected_option: int = Options.PRIMER_SLOT

@onready var options: Dictionary = {
	Options.PRIMER_SLOT: $Zona_Seleccion/PrimerSlot/fondo,
	Options.SEGUNDO_SLOT: $Zona_Seleccion/SegundoSlot/fondo,
	Options.TERCER_SLOT: $Zona_Seleccion/TercerSlot/fondo,
	Options.CUARTO_SLOT: $Zona_Seleccion/CuartoSlot/fondo,
	Options.QUINTO_SLOT: $Zona_Seleccion/QuintoSlot/fondo,
	Options.SEXTO_SLOT: $Zona_Seleccion/SextoSlot/fondo,
	Options.CANCEL: $Zona_Seleccion/CANCEL
}
enum Anim { PRIMER, SEGUNDO, TERCER, CUARTO, QUINTO, SEXTO, CANCEL }
var selected_Anim: int = Anim.PRIMER

@onready var anims: Dictionary = {
	Anim.PRIMER: $Zona_Seleccion/PrimerSlot/AnimationPlayer,
	Anim.SEGUNDO: $Zona_Seleccion/SegundoSlot/AnimationPlayer,
	Anim.TERCER: $Zona_Seleccion/TercerSlot/AnimationPlayer,
	Anim.CUARTO: $Zona_Seleccion/CuartoSlot/AnimationPlayer,
	Anim.QUINTO: $Zona_Seleccion/QuintoSlot/AnimationPlayer,
	Anim.SEXTO: $Zona_Seleccion/SextoSlot/AnimationPlayer,
	Anim.CANCEL: null
}

@onready var opciones = $Zona_Seleccion.get_child_count()

var equipo: Array = []

func unset_active_option():
	options[selected_option].frame = 0
	if selected_Anim != Anim.CANCEL:
		anims[selected_Anim].speed_scale = 1

func set_active_option():
	options[selected_option].frame = 1
	if selected_Anim != Anim.CANCEL:
		anims[selected_Anim].speed_scale = 5.0

func _ready():
	equipo = Utils.get_Player().equipo
	actualizar_slots()
	set_active_option()

func actualizar_slots():
	for i in range(Options.PRIMER_SLOT, Options.SEXTO_SLOT + 1):
		if i < equipo.size():
			var pokemon = equipo[i]
			options[i].get_parent().get_node("pokemonName").texture = pokemon.sprite
			options[i].get_parent().get_node("pokemon").texture = pokemon.sprite
			options[i].get_parent().get_node("LevelLabel").text = "%d" % pokemon.nivel
			options[i].get_parent().get_node("VidaLabel").text = "%d" % pokemon.hp_actual
			options[i].get_parent().get_node("VidaMaxLabel").text = "%d" % pokemon.hp_max
			options[i].get_parent().get_node("Genero").show()
			options[i].get_parent().get_node("TextureProgressBar").show()
			options[i].get_parent().get_node("fondo").show()
		else:
			options[i].get_parent().get_node("pokemonName").texture = null
			options[i].get_parent().get_node("pokemon").texture = null
			options[i].get_parent().get_node("LevelLabel").text = ""
			options[i].get_parent().get_node("VidaLabel").text = ""
			options[i].get_parent().get_node("VidaMaxLabel").text = ""
			options[i].get_parent().get_node("Genero").hide()
			options[i].get_parent().get_node("TextureProgressBar").hide()
			options[i].get_parent().get_node("fondo").hide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("move_down"):
		unset_active_option()
		while true:
			selected_option = (selected_option + 1) % opciones
			selected_Anim = (selected_Anim + 1) % opciones
			if selected_option == Options.CANCEL or selected_option < equipo.size():
				break
		set_active_option()
	elif event.is_action_pressed("move_up"):
		unset_active_option()
		while true:
			if selected_option == 0:
				selected_option = Options.CANCEL
				selected_Anim = Anim.CANCEL
			else:
				selected_option -= 1
				selected_Anim -= 1
			if selected_option == Options.CANCEL or selected_option < equipo.size():
				break
		set_active_option()
	elif event.is_action_pressed("move_left"):
		unset_active_option()
		selected_option = 0
		selected_Anim = 0
		set_active_option()
	elif event.is_action_pressed("move_right"):
		unset_active_option()
		if selected_option == Options.PRIMER_SLOT and selected_option > equipo.size():
			selected_option = 1
			selected_Anim = 1
		if selected_option == Options.PRIMER_SLOT and selected_option < equipo.size():
			selected_option = 6
			selected_Anim = 6
		set_active_option()
	elif event.is_action_pressed("A"):
		match selected_option:
			Options.CANCEL:
				Utils.get_administrador_escenas().trancicion_salir_partysceen()	
			Options.PRIMER_SLOT, Options.SEGUNDO_SLOT, Options.TERCER_SLOT, Options.CUARTO_SLOT, Options.QUINTO_SLOT, Options.SEXTO_SLOT:
				print(equipo[0].movimientos)
