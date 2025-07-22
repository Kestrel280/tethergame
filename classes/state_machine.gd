class_name State_Machine
extends Node


@export var current_state : State;
var states : Dictionary = {};


func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name] = child;
	current_state.enter();


func _process(dt : float):
	current_state.update(dt);


func _physics_process(dt : float):
	current_state.physics_update(dt);


func transition(new_state_name : StringName) -> void:
	var new_state = states.get(new_state_name);
	if (new_state != null) and (new_state != current_state):
		current_state.exit();
		new_state.enter();
		current_state = new_state;
