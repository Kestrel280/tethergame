extends Node


@export var player : GDScript;


func _ready() -> void:
	# Connect signals
	Message_Bus.change_level_requested.connect(change_level);
	Message_Bus.quit_requested.connect(close_game);
	Message_Bus.pause_requested.connect(try_pause);
	change_level("main_menu");


@warning_ignore("unused_parameter")
func _unhandled_input(event : InputEvent):
	if Input.is_action_just_pressed("pause"): try_pause();
		


func try_pause():
	var pmenu : Node = preload("res://pause_menu.tscn").instantiate();
	add_child(pmenu);
	move_child(pmenu, 0);


func change_level(level_name : String):
	# Wipe the current level
	for child in $Level_Container.get_children(): child.queue_free();
	Globals.debug_panel.remove_all_properties();
	
	# Load the new level
	var level_path : String = "res://maps/%s/%s.tscn" % [level_name, level_name];
	var level_scn : PackedScene = load(level_path);
	if !level_scn: assert(false, "No level named %s" % level_name);
	var level : Level = level_scn.instantiate();
	$Level_Container.add_child(level);
	level.do_intro();
	level.spawn_player(player.construct());


func close_game():
	get_tree().quit();
