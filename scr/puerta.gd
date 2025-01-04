@icon("res://IconGodotNode/IconGodotNode/node_2D/icon_door.png")
extends Area2D

@export_file() var nueva_escena = ""
@export var es_invisible: bool = false

@export var spawn_location: Vector2 = Vector2(0,0)

@export var spawn_direction: Vector2 = Vector2(0, 0)

@onready var Sprite: Sprite2D = $Sprite2D
@onready var anim : AnimationPlayer = $AnimationPlayer

var player_entered: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if es_invisible:
		Sprite.texture = null
	Sprite.hide()
	var player = Utils.get_Player()
	player.connect("player_entrando_signal", Callable(self, "entrando"))
	player.connect("player_entro_signal", Callable(self, "cerrar"))

func entrando():
	if player_entered:
		anim.play("Abrir_Puerta")

func cerrar():
	if player_entered:
		anim.play("Cerrar_Puerta")

func puerta_cerrada():
	if player_entered:
		Utils.get_administrador_escenas().Trancicion_Escena(nueva_escena, spawn_location, spawn_direction)



func _on_body_entered(_body: Node2D) -> void:
	player_entered = true


func _on_body_exited(_body: Node2D) -> void:
	player_entered = false
