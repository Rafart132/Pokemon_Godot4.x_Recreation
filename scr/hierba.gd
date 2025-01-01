extends Node2D

@onready var anim = $AnimationPlayer
const grass_overlay_textur = preload("res://Assets/Grass/stepped_tall_grass.png")
const grass_effect = preload("res://Escenas/hierba_efecto.tscn")
var grass_overlay: TextureRect = null

var player_inside: bool = false

func _ready() -> void:
	anim.play("Idle")
	await get_tree().create_timer(.5).timeout
	var player = Utils.get_Player()
	player.connect("player_moving_signal", Callable(self, "player_exiting_grass"))
	player.connect("player_stooped_signal", Callable(self, "player_in_grass"))

func player_exiting_grass():
	player_inside = false
	if is_instance_valid(grass_overlay):
		grass_overlay.queue_free()

func player_in_grass():
	if player_inside == true:
		var EffectoPaso = grass_effect.instantiate()
		EffectoPaso.position = position
		get_tree().current_scene.add_child(EffectoPaso)
		
		grass_overlay = TextureRect.new()
		grass_overlay.texture = grass_overlay_textur
		grass_overlay.position = Vector2(position.x, position.y) + Vector2(-8, -8)
		get_tree().current_scene.add_child(grass_overlay)

func _on_area_2d_body_entered(_body: CharacterBody2D) -> void:
	player_inside = true
	anim.play("pasando")
