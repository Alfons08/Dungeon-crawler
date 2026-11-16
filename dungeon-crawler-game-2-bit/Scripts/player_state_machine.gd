extends Node2D

class_name PlayerStateMachine

#referens till player
@onready var player: Player = get_parent()
#referens till "staten"
var current_state: PlayerState = null

"""


"""


func _ready() -> void:

	# Give every state access to the player and state machine
	
	for child in get_children():
		var state = child as PlayerState

		if state:
			state.player = player
			state.state_machine = self

	# Start in Idle
	transition_to("Idle")


func _physics_process(delta: float) -> void:
	#physics process för "staten"
	if current_state:
		current_state.physics_update(delta)


func transition_to(state_name: String) -> void:

	var next_state = get_node_or_null(state_name) as PlayerState

	if next_state == null:
		push_error("State not found: " + state_name)
		return

	if current_state == next_state:
		return

	# Lämna nuvarande "state"
	if current_state:
		current_state.exit()

	# Aktivera nytt "state"
	current_state = next_state
	current_state.enter()
