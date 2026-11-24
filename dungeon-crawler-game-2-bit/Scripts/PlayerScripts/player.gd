extends CharacterBody2D
class_name Player

@export var tile_size: int = 12
@export var move_speed: float = 8.0


@export var turn_manager: TurnManager 
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var ray_cast: RayCast2D = $RayCast2D

var target_position: Vector2 = Vector2.ZERO
var current_direction: Vector2 = Vector2.ZERO
var queued_direction: Vector2 = Vector2.ZERO




func _ready() -> void:
	add_to_group("player")
	#sätt spelaren på kanten av en ruta
	position = position.snapped(Vector2(tile_size, tile_size))
	target_position = position
	turn_manager.player_turn_started.connect(_on_player_turn_started)
	turn_manager.player_turn_ended.connect(_on_player_turn_ended)
	
	
	
func _on_player_turn_started()->void:
	print("Player turn started")
	

func _on_player_turn_ended()->void:
	print("Player turn ended")
	

	
	
	
	
func get_just_pressed_direction() -> Vector2:
	#funktion som kikar ifall en ny riktning har angivits
	#ger en queued direction
	if Input.is_action_just_pressed("down"):
		return Vector2.DOWN
	elif Input.is_action_just_pressed("up"):
		return Vector2.UP
	elif Input.is_action_just_pressed("right"):
		return Vector2.RIGHT
	elif Input.is_action_just_pressed("left"):
		return Vector2.LEFT

	return Vector2.ZERO


func get_held_direction() -> Vector2:
	
	if Input.is_action_pressed("right"):
		return Vector2.RIGHT
	elif Input.is_action_pressed("left"):
		return Vector2.LEFT
	elif Input.is_action_pressed("down"):
		return Vector2.DOWN
	elif Input.is_action_pressed("up"):
		return Vector2.UP

	return Vector2.ZERO


func is_action_held() -> bool:
	if Input.is_action_pressed("right"): return true
	if Input.is_action_pressed("left"): return true	
	if Input.is_action_pressed("up"): return true
	if Input.is_action_pressed("down"): return true
	return false


func can_move_in(direction: Vector2) -> bool:

	ray_cast.target_position = direction * tile_size
	ray_cast.force_raycast_update()
	if ray_cast.is_colliding():
		return false
	else:
		return true
	
		

func start_move(direction: Vector2) -> void:

	current_direction = direction
	target_position = position + direction * tile_size
	
	
