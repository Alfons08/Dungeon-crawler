extends CharacterBody2D

class_name Enemy

@export var tile_size: int = 12
@export var move_speed: float = 8.0
@export var vision_range: float = 120.0



@onready var vision_ray: RayCast2D = $VisionRay
@onready var move_ray: RayCast2D = $MoveRay
@export var ground_layer: TileMapLayer


var home_position: Vector2
var target_position: Vector2
var is_moving:bool = false
var previous_direction: Vector2 = Vector2.ZERO
var roam_radius: int = 5

func _ready() -> void:
	add_to_group("enemies")
	var half_tile = Vector2(tile_size,tile_size)/2
	#removes half a tile from the position
	var adjusted_position = global_position-half_tile
	#snaps to nearest tile cordinate
	adjusted_position = adjusted_position.snapped(Vector2(tile_size,tile_size))
	#move back to tile center
	global_position = adjusted_position + half_tile
	
	home_position = global_position
	target_position = global_position

func can_move(direction:Vector2)->bool:
	var next_position = global_position + direction*tile_size
	#check that ground exist
	if not has_ground_tile(next_position):
		return false
	
	
	move_ray.target_position = direction*tile_size
	move_ray.force_raycast_update()
	
	if move_ray.is_colliding():
		return false
	return true

func start_move(direction:Vector2)->void:
	if is_moving or direction == Vector2.ZERO:
		return
	if not can_move(direction):
		return
	target_position = global_position + direction*tile_size
	
	previous_direction = direction
	is_moving = true

func update_movement(delta:float)->bool:
	global_position = global_position.move_toward(target_position,tile_size*move_speed*delta)
	
	if global_position.distance_to(target_position) < 0.1:
		global_position = target_position
		is_moving = false
		return true
	return false
		
func get_random_direction()->Vector2:
	var directions: Array = [Vector2.UP,Vector2.DOWN,Vector2.LEFT,Vector2.RIGHT]
	var available_directions: Array[Vector2] = []
	
	for direction in directions:
		var next_position = global_position + direction*tile_size
		#if the new direction is within range and is available add to possible
		if next_position.distance_to(home_position) < roam_radius*tile_size:
			if can_move(direction):
				available_directions.append(direction)
	
	#delete previous direction if it's possible
	if available_directions.size() > 1:
		available_directions.erase(-previous_direction)
	
	if available_directions.is_empty():
		return Vector2.ZERO
		
	return available_directions.pick_random()
		
		
			

func can_see_player() -> bool:

	# Find the player
	var player = get_tree().get_first_node_in_group("player")

	if player == null:
		return false

	# Check distance
	var distance_to_enemy = global_position.distance_to(
		player.global_position
	)

	if distance_to_enemy > vision_range:
		return false

	# Point ray towards player
	vision_ray.target_position = vision_ray.to_local(player.global_position)

	vision_ray.force_raycast_update()

	# Check if ray hits player
	return vision_ray.get_collider() == player
	
func has_ground_tile(world_position:Vector2)->bool:
	
	var local_position = ground_layer.to_local(world_position)
	var cell = ground_layer.local_to_map(local_position)
	
	if ground_layer.get_cell_source_id(cell) == -1:
		return false
	return true
