extends Node


func get_Player():
	return get_node("/root/AdministradorEscenas/EscenaActual").get_children().back().find_child("Bruno")

func get_administrador_escenas():
	return get_node("/root/AdministradorEscenas")

func Spawn(): 
	return get_node("/root/AdministradorEscenas/EscenaActual").get_children().back().find_child("spawn")
