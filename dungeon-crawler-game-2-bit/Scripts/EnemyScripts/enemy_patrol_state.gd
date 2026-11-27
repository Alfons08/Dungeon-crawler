extends EnemyState


var pause_timer:float = 0.0 

func enter() -> void:
	print("enemy started patrolling")
	
func physics_update(_delta: float) -> void:

	#updates vision ray
	if enemy.can_see_player():
		
		print("player detected")
		
		GameManager.start_combat()
		
		state_machine.transition_to("ChaseState")

	#otherwise walks to nearby tile
	"""
	if GameManager.current_mode == GameManager.GameMode.COMBAT:
		return
	"""
	
	if enemy.is_moving:
		
		var finished_movement = enemy.update_movement(_delta)
		
		if finished_movement:
			#add a timer between movement
			pause_timer = randf_range(0.25,1)
		return
	
	if pause_timer >0:
		pause_timer-=_delta
		return
	var direction = enemy.get_random_direction()
	if direction == Vector2.ZERO:
		#i dont know if i should add this code since it likely wont happen
		pause_timer = randf_range(0.25,1)
		return
	
	enemy.start_move(direction)
			
	
		
	
func exit()->void:
	pass
