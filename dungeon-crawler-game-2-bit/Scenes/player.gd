extends CharacterBody2D

@export var tile_size: int = 12
@export var move_speed: float = 6.0 #speed of movementbetween tiles




@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var ray_cast: RayCast2D = $RayCast2D

var is_moving: bool = false
var target_position: Vector2 = Vector2.ZERO

func _ready() -> void:
	#flyttar karaktär till kanten av en tile
	position = position.snapped(Vector2(tile_size,tile_size))
	target_position = position

func _physics_process(delta: float) -> void:
	if is_moving:
		position = position.move_toward(target_position, move_speed*tile_size*delta)
		#kan updatera animation här:
		
		#check if we reached targeted tile.
		if position.distance_to(target_position) < 0.1:
			position = target_position
			is_moving = false
		#kan stoppa animation här:
	else:	
		handle_input()
	
func handle_input() -> void:
	var input_direction: Vector2 = Vector2.ZERO
	input_direction = Input.get_vector("Left","Right","Up","Down")
	
	"""if Input.is_action_pressed("Right"):
		input_direction = Vector2(1,0)
	elif Input.is_action_pressed("Left"):
		input_direction = Vector2(-1,0)
	elif Input.is_action_pressed("Down"):
		input_direction = Vector2(0,1)
	elif Input.is_action_just_pressed("Up"):
		input_direction = Vector2(0,-1)	"""
		
	if input_direction != Vector2.ZERO:
		move_to_tile(input_direction)

func move_to_tile(direction: Vector2)->void:
	#point raycast to targeted direction
	
	ray_cast.target_position = direction * tile_size
	ray_cast.force_raycast_update()
	
	if ray_cast.is_colliding() != true:
		target_position = position + (direction*tile_size)
		is_moving = true	
	
