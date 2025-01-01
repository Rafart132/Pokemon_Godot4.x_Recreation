@icon("res://IconGodotNode/IconGodotNode/color/icon_particle.png")
extends AnimatedSprite2D


func _ready() -> void:
	frame = 0
	


func _on_animation_finished() -> void:
	queue_free()
