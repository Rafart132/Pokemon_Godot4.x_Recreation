extends Resource

class_name PokemonData

@export var nombre: String = "Sin Nombre"
@export var sprite: Texture = null
@export var nivel: int = 1
@export var hp_actual: int = 10
@export var hp_max: int = 10
@export var experiencia: int = 0
@export var movimientos: Array[String] = []
@export var objeto: String = ""  # Objeto equipado
@export var notas_entrenador: String = ""  # Información adicional
