class_name State
extends Node


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
