extends Node


@export var player : GDScript;


func _unhandled_input(event) -> void:
	if event is InputEventKey:
		if event.is_action_pressed("debug_quit_to_main_menu"):
			MessageBus.quit_to_menu_requested.emit();


func _ready() -> void:
	# Connect signals
	MessageBus.change_level_requested.connect(change_level);
	MessageBus.quit_requested.connect(close_game);
	MessageBus.quit_to_menu_requested.connect(func(): change_level("main_menu"));
	change_level("main_menu");


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
