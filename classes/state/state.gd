class_name State
extends Node


# Reference to the state machine that this state is installed within
@onready var sm : State_Machine = get_parent();


# Children should define a static var state_name : StringName

@warning_ignore_start("unused_parameter")
func enter() -> void:
	pass;


func exit() -> void:
	pass;


func update(dt : float) -> void:
	pass;


func physics_update(dt : float) -> void:
	pass;
@warning_ignore_restore("unused_parameter")
