extends Node

class_name TurnManager

signal player_turn_started
signal player_turn_ended
signal action_points_changed(amount: int)
signal enemy_turn_started

@export var max_action_points:int = 1

var action_points:int = 0
var is_player_turn:bool = true



func start_player_turn()->void:
	is_player_turn = true
	action_points = max_action_points
	
	player_turn_started.emit()
	action_points_changed.emit(max_action_points)
	
func can_perform_action(cost:int)->bool:
	if is_player_turn and action_points >= 1 and cost > 0:
		return true
	return false
	
func spend_action_point(cost:int)->void:
	if not can_perform_action(cost):
		return
	if can_perform_action(cost):
		action_points -= cost
		action_points_changed.emit(cost)
	if action_points <= 0:
		end_player_turn()
	
	
func end_player_turn()->void:
	
	if not is_player_turn:
		return

	is_player_turn = false
	
	player_turn_ended.emit()
	enemy_turn_started.emit()
	
func finish_enemy_turn()->void:
	start_player_turn()
	
	
	
