class_name Level
extends Node


# Don't override these
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED);


# Override these
func spawn_player(player : Player) -> void:
	add_child(player);


func do_intro() -> void:
	pass;
