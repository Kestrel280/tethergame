class_name Level
extends Node


func spawn_player() -> void:
	pass;


# If levels need setup, or want to do a cutscene, this is where they should do it
func do_intro() -> void:
	pass


# Levels should not override _ready()
func _ready() -> void:
	do_intro();


func _process(delta: float) -> void:
	pass
