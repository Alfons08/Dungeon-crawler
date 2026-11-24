extends CharacterBody2D

class_name Enemy

@export var tile_size: int = 12
@export var move_speed: float = 8.0
@export var vision_range: float = 120.0


@onready var vision_ray: RayCast2D = $VisionRay
	

func _ready() -> void:
	add_to_group("enemies")


func can_see_player() -> bool:

	# Find the player
	var player = get_tree().get_first_node_in_group("player")

	if player == null:
		return false

	# Check distance
	var distance = global_position.distance_to(
		player.global_position
	)

	if distance > vision_range:
		return false

	# Point ray towards player
	vision_ray.target_position = vision_ray.to_local(
		player.global_position
	)

	vision_ray.force_raycast_update()

	# Check if ray hits player
	return vision_ray.get_collider() == player
