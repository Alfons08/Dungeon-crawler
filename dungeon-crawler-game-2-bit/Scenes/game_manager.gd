extends Node

class_name GameManager

enum GameMode {
	EXPLORATION,
	COMBAT}



var current_mode: GameMode = GameMode.COMBAT

signal game_mode_changed(new_mode)


func start_combat() -> void:

	if current_mode == GameMode.COMBAT:
		return

	current_mode = GameMode.COMBAT
	game_mode_changed.emit(current_mode)


func end_combat() -> void:

	if current_mode == GameMode.EXPLORATION:
		return

	current_mode = GameMode.EXPLORATION
	game_mode_changed.emit(current_mode)
