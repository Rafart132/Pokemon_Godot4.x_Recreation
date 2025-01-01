extends CharacterBody2D

@warning_ignore("unused_signal")
signal player_moving_signal
@warning_ignore("unused_signal")
signal player_stooped_signal

@warning_ignore("unused_signal")
signal player_entrando_signal
@warning_ignore("unused_signal")
signal player_entro_signal


@onready var sprite : Sprite2D = $Sprite2D
@onready var sombra : Sprite2D = $Sombra

@export var walk_speed = 5.0
@export var jump_speed = 4.0

const PolvoEffect = preload("res://Escenas/polvo.tscn")

const TILE_SIZE = 16


@onready var anim_tree: AnimationTree = $AnimationTree
@onready var anim_state = anim_tree.get("parameters/playback")

@onready var Ray : RayCast2D = $ColicionRayCast2D
@onready var SalienteRay : RayCast2D = $SalienteRayCast2D
@onready var RayPuerta : RayCast2D = $PuertasRayCast2D


var SaltandoSaliente : bool = false

enum PlayerState {IDLE, TURNING, WALKING, RUNNING}
enum Direcciones {LEFT, RIGHT, UP, DOWN}

var player_state = PlayerState.IDLE
var direccion = Direcciones.DOWN

var initial_position: Vector2 = Vector2(0,0)
var input_direction: Vector2 = Vector2(0,1)

var is_moving: bool = false
var percent_moved_to_next_tile: float = 0.0

var detener_input : bool = false

func _ready() -> void:
	sprite.visible = true
	anim_tree.active = true
	initial_position = position
	sombra.hide()
	anim_tree.set("parameters/Idle/blend_position", input_direction)
	anim_tree.set("parameters/Walk/blend_position", input_direction)
	anim_tree.set("parameters/Turn/blend_position", input_direction)

func set_spawn(locacion: Vector2, direction: Vector2):
	anim_tree.set("parameters/Idle/blend_position", direction)
	anim_tree.set("parameters/Walk/blend_position", direction)
	anim_tree.set("parameters/Turn/blend_position", direction)
	position = locacion

func _physics_process(delta):
	if player_state == PlayerState.TURNING or detener_input:
		return
	if is_moving == false:
		handle_movement_input()
	elif input_direction != Vector2.ZERO:
		anim_state.travel("Walk")
		move(delta)
	else:
		anim_state.travel("Idle")
		is_moving = false
	
		
		
func handle_movement_input():
	if input_direction.y == 0:
		input_direction.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	if input_direction.x == 0:
		input_direction.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	
	if input_direction != Vector2.ZERO:
		anim_tree.set("parameters/Idle/blend_position", input_direction)
		anim_tree.set("parameters/Walk/blend_position", input_direction)
		anim_tree.set("parameters/Turn/blend_position", input_direction)
		
		if need_turn():
			player_state = PlayerState.TURNING
			anim_state.travel("Turn")
		else:
			initial_position = position
			is_moving = true
		
	else:
		anim_state.travel("Idle")
	

func need_turn():
	var _new_direccion
	if input_direction.x < 0:
		_new_direccion = Direcciones.LEFT
	elif input_direction.x > 0:
		_new_direccion = Direcciones.RIGHT
	elif input_direction.y < 0:
		_new_direccion = Direcciones.UP
	elif input_direction.y > 0:
		_new_direccion = Direcciones.DOWN
	
	if direccion != _new_direccion:
		direccion = _new_direccion
		return true
	direccion = _new_direccion
	return false

func finished_turning():
	player_state = PlayerState.IDLE

func entrando():
	emit_signal("player_entro_signal")

func move(delta):
	
	var paso_permitido: Vector2 = input_direction * TILE_SIZE / 2
	Ray.target_position = paso_permitido
	Ray.force_raycast_update()
	
	SalienteRay.target_position = paso_permitido
	SalienteRay.force_raycast_update()
	
	RayPuerta.target_position = paso_permitido
	RayPuerta.force_raycast_update()
	
	if RayPuerta.is_colliding():
		if percent_moved_to_next_tile == 0.0:
			emit_signal("player_entrando_signal")
		percent_moved_to_next_tile += walk_speed * delta
		if percent_moved_to_next_tile >= 1.0:
			position = initial_position + (input_direction * TILE_SIZE)
			percent_moved_to_next_tile = 0.0
			is_moving = false
			detener_input = true
			sprite.visible = false
			$AnimationPlayer.play("D")


		else:
			position = initial_position + (input_direction * TILE_SIZE * percent_moved_to_next_tile)
	
	elif (SalienteRay.is_colliding() && input_direction == Vector2(0, 1)) or SaltandoSaliente:
		percent_moved_to_next_tile += jump_speed * delta
		if percent_moved_to_next_tile >= 2.0:
			position = initial_position + (input_direction * TILE_SIZE * 2)
			percent_moved_to_next_tile = 0.0
			is_moving = false
			SaltandoSaliente = false
			sombra.hide()
			
			var Polvito = PolvoEffect.instantiate()
			Polvito.position = position
			get_tree().current_scene.add_child(Polvito)
			
		else:
			sombra.show()
			SaltandoSaliente = true
			var input = input_direction.y * TILE_SIZE * percent_moved_to_next_tile
			position.y = initial_position.y + (-0.96 - 0.53 * input + 0.05 * pow(input, 2))
			sombra.position.y = initial_position.y - position.y - (2 + 0.37 * input - 0.043 * pow(input, 2))
			
	elif !Ray.is_colliding():
		if percent_moved_to_next_tile == 0:
			emit_signal("player_moving_signal")
		percent_moved_to_next_tile += walk_speed * delta
		if percent_moved_to_next_tile >= 1.0:
			position = initial_position + (input_direction * TILE_SIZE)
			percent_moved_to_next_tile = 0.0
			is_moving = false
			emit_signal("player_stooped_signal")
		else:
			position = initial_position + (input_direction * TILE_SIZE * percent_moved_to_next_tile)
	else:
		is_moving = false
