extends PlayerState

func enter() -> void:
	print("Entered Idle")


func physics_update(_delta: float) -> void:

	# Get player movement input
	var direction = player.get_held_direction()

	if direction == Vector2.ZERO:
		return

	# Check whether the destination tile is available
	if player.can_move_in(direction):

		# Start movement
		player.start_move(direction)

		# Change state
		state_machine.transition_to("MovingState")


func exit() -> void:
	print("Exited Idle")
