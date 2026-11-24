extends PlayerState

func enter() -> void:
	pass


func physics_update(_delta: float) -> void:
	
	
	
	
	# Get player movement input
	var direction: Vector2


	if GameManager.current_mode == GameManager.GameMode.COMBAT:
		#check if player can perform action
		if not player.turn_manager.can_perform_action(1):
				return
		direction = player.get_just_pressed_direction()
	else:
		direction = player.get_held_direction()
	
	
	
	if direction == Vector2.ZERO:
		return

	# Check whether the destination tile is available
	if player.can_move_in(direction):

		# Start movement
		player.start_move(direction)

		# Change state
		state_machine.transition_to("MovingState")


func exit() -> void:
	pass
