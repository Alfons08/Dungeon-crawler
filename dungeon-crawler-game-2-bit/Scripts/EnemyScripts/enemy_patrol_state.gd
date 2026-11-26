extends EnemyState


func enter() -> void:
	print("enemy started patrolling")
	
func physics_update(_delta: float) -> void:
	
	#updates vision ray
	if enemy.can_see_player():
		
		print("player detected")
		
		GameManager.start_combat()
		
		state_machine.transition_to("ChaseState")
	#otherwise walks to nearby tile
	
	
	
		
	
func exit()->void:
	pass
