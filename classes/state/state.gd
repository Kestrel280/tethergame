class_name State
extends Node


# Reference to the state machine that this state is installed within
@onready var sm : State_Machine = get_parent();


# Children should define a static var state_name : StringName


func enter() -> void:
	pass;


func exit() -> void:
	pass;


func update(_dt : float) -> void:
	pass;


func physics_update(_dt : float) -> void:
	pass;
