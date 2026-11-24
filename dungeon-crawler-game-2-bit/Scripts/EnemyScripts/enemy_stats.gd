extends Node

class_name Stats

signal health_changed(amount:int)
signal died

@export var max_health: int = 10

var current_health: int

func _ready() -> void:
	current_health = max_health

func take_damage(amount:int)->void:
	
	if current_health <= 0 or amount <= 0:
		return
	
	current_health = max(0, current_health - amount)
	
	health_changed.emit(current_health)
	
	if current_health == 0:
		died.emit()
		
