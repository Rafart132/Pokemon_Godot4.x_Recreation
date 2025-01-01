extends Node


func _ready() -> void:
	pass

func get_Player():
	return get_node("/root/AdministradorEscenas/EscenaActual").get_children().back().find_child("Bruno")

func get_administrador_escenas():
	return get_node("/root/AdministradorEscenas")
