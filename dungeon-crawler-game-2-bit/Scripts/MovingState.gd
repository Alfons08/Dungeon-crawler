extends PlayerState


func enter() -> void:
	print("Entered Moving")

"""
Detta med state machines fick jag lära mig att 
man vill dela upp till olika scripts. 
Var tvungen att ta hjälp av guides för att lösa detta. 
Men själva grundkoden har jag gjort. 
Bara att först detta med classes
"""

func physics_update(delta: float) -> void:

	# 1. Check if player pressed a new direction
	var new_direction = player.get_just_pressed_direction()

	if new_direction != Vector2.ZERO:
		player.queued_direction = new_direction


	# 2. Move towards the target tile
	player.position = player.position.move_toward(player.target_position,player.move_speed * player.tile_size * delta)


	# 3. Check if target tile has been reached
	if player.position.distance_to(player.target_position) < 0.1:

		player.position = player.target_position

		# 4. Determine the next direction
		var next_direction = player.queued_direction
		player.queued_direction = Vector2.ZERO

		# If no direction is queued, continue current movement
		if next_direction == Vector2.ZERO and player.is_action_held():
			next_direction = player.current_direction

		# 5. Start the next movement if possible
		if next_direction != Vector2.ZERO and player.can_move_in(next_direction):
			player.start_move(next_direction)
			return

		# If the queued direction was blocked, try continuing straight
		if player.is_action_held() and player.current_direction != Vector2.ZERO:
			if player.can_move_in(player.current_direction):
				player.start_move(player.current_direction)
				return

		# 6. Otherwise, stop and return to Idle
		player.current_direction = Vector2.ZERO
		state_machine.transition_to("Idle")


func exit() -> void:
	print("Exited Moving")
