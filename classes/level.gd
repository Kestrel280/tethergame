class_name Level
extends Node

# Useful for changelevel to know when the intro is done. Flag + signal allows us to check once and only await if required. (If only signal, we might not connect to the signal in time)
var is_intro_finished : bool = false;
signal intro_finished;


func spawn_player() -> void:
	pass;


# If levels need setup, or want to do a cutscene, this is where they should do it
func do_intro() -> void:
	pass


# Levels should not override _ready()
func _ready() -> void:
	do_intro();
	intro_finished.emit();
	is_intro_finished = true;

func _process(delta: float) -> void:
	pass
