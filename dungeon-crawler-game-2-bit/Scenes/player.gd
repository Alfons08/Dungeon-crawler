extends CharacterBody2D

@export var tile_size: int = 12
@export var move_speed: float = 8.0 #speed of movementbetween tiles




@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var ray_cast: RayCast2D = $RayCast2D

var is_moving: bool = false
var target_position: Vector2 = Vector2.ZERO
var current_direction: Vector2 = Vector2.ZERO
var queued_direction: Vector2 = Vector2.ZERO


func _ready() -> void:
	#flyttar karaktär till kanten av en tile
	position = position.snapped(Vector2(tile_size,tile_size))
	target_position = position

func _physics_process(delta: float) -> void:
	get_input()
	
	
	if is_moving:
		position = position.move_toward(target_position, move_speed*tile_size*delta)
		#kan updatera animation här:
		
		
		#check if we reached targeted tile.
		if position.distance_to(target_position) < 0.1:
			position = target_position
			is_moving = false
			#kan stoppa animation här
	#initiate new movement when not moving
	if not is_moving:
		# check if a queued direction 
		if queued_direction != Vector2.ZERO:
			current_direction = queued_direction
			queued_direction = Vector2.ZERO
		#check if all movement keys have been released
		elif not is_action_held():
			current_direction = Vector2.ZERO
		#if we have no direction, check current input
		elif current_direction == Vector2.ZERO:
			current_direction = get_held_direction()
		#start moving if we have a new direction
		if current_direction != Vector2.ZERO:
			move_to_tile(current_direction)

		
	
	

	
#-------------- Hjälpfunktioner	--------------------
	
func get_input() -> void:
	#problem med att göra det möjligt att byta riktning medan man går
	#funkar att göra med höger och vänster men inte med up och ner
	#har testat att byta namnen på inputsen och det funkar icke
	
	#1. Check newly pressed actions
	if Input.is_action_just_pressed("down"):
		current_direction = Vector2(0,1)
		
	elif Input.is_action_just_pressed("up"):
		current_direction = Vector2(0,-1)
		
	elif Input.is_action_just_pressed("right"):
		current_direction = Vector2(1,0)
		
	elif Input.is_action_just_pressed("left"):
		current_direction = Vector2(-1,0)
		
		
func is_action_held()->bool:
	if Input.is_action_pressed("down"): return true	
	if Input.is_action_pressed("up"): return true
	if Input.is_action_pressed("right"): return true
	if Input.is_action_pressed("left"): return true
	return false

func get_held_direction()->Vector2:
	if Input.is_action_pressed("right"): return Vector2(1, 0)
	if Input.is_action_pressed("left"): return Vector2(-1, 0)
	if Input.is_action_pressed("down"): return Vector2(0, 1)
	if Input.is_action_pressed("up"): return Vector2(0, -1)
	return Vector2.ZERO


func move_to_tile(direction: Vector2)->void:
	#point raycast to targeted direction
	
	ray_cast.target_position = direction * tile_size
	ray_cast.force_raycast_update()
	
	if ray_cast.is_colliding() != true:
		target_position = position + (direction*tile_size)
		is_moving = true
		
	else:
		#stop movement
		current_direction = Vector2.ZERO
