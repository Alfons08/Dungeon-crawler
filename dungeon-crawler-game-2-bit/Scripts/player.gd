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
		elif not is_direction_held(current_direction):
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
	
	#Nu har jag fixat problemet men det är fortfarande
	#lite skumt med movement
	
	#1. Check newly pressed actions
	
	var new_direction = Vector2.ZERO
	
	if Input.is_action_just_pressed("down"):
		new_direction = Vector2(0, 1)

	elif Input.is_action_just_pressed("up"):
		new_direction = Vector2(0, -1)

	elif Input.is_action_just_pressed("right"):
		new_direction = Vector2(1, 0)

	elif Input.is_action_just_pressed("left"):
		new_direction = Vector2(-1, 0)

	if new_direction != Vector2.ZERO:
		queued_direction = new_direction
	
		
func is_direction_held(direction: Vector2) -> bool:
	
	if direction == Vector2.RIGHT:
		return Input.is_action_pressed("right")
	if direction == Vector2.LEFT:
		return Input.is_action_pressed("left")
	if direction == Vector2.UP:
		return Input.is_action_pressed("up")
	if direction == Vector2.DOWN:
		return Input.is_action_pressed("down")
	return false

func get_held_direction()->Vector2:
	if Input.is_action_pressed("right"): 
		return Vector2(1, 0)
	if Input.is_action_pressed("left"): 
		return Vector2(-1, 0)
	if Input.is_action_pressed("down"): 
		return Vector2(0, 1)
	if Input.is_action_pressed("up"): 
		return Vector2(0, -1)
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


#--------------States----------------------
