extends Node


@export var player : GDScript;


func _ready() -> void:
	# Connect signals
	Message_Bus.change_level_requested.connect(change_level);
	Message_Bus.quit_requested.connect(close_game);
	Message_Bus.pause_requested.connect(try_pause);
	Message_Bus.join_server_requested.connect(join_server);
	change_level("main_menu");
	
	if OS.has_feature("dedicated_server") or OS.has_feature("dedicated_server_interactive"):
		var server : Server = Server.new();
		server.name = "Server";
		add_child.call_deferred(server);
		server.start.call_deferred();


func _unhandled_input(_event : InputEvent):
	if Input.is_action_just_pressed("pause"): try_pause();


func try_pause():
	var pmenu : Node = preload("res://ui/pause_menu/pause_menu.tscn").instantiate();
	add_child(pmenu);
	move_child(pmenu, 0);


func change_level(level_name : String, network_manager : Client = null):
	# If this changelevel-request was NOT created by a server, make sure we disconnect from any current server
	# Set network_manager to our disconnected Client node
	if network_manager == null:
		$Client.stop();
		network_manager = $Client;
	
	# Wipe the current level
	for child in $Level_Container.get_children(): child.queue_free();
	Globals.debug_panel.remove_all_properties();
	
	# Load the new level
	var level_path : String = "res://maps/%s/%s.tscn" % [level_name, level_name];
	var level_scn : PackedScene = load(level_path);
	if !level_scn: assert(false, "No level named %s" % level_name);
	var level : Level = level_scn.instantiate();
	$Level_Container.add_child(level);
	Globals.level = level;
	if not OS.has_feature("dedicated_server"):
		level.do_intro();
		level.spawn_player(Player.construct(network_manager));


func join_server(ip : String):
	$Client.stop();
	var pop_up : Control = preload("res://ui/pop_up.tscn").instantiate();
	pop_up.get_node("Label").text = "Attempting to join server...";
	add_child(pop_up);
	await $Client.start(ip);
	if !$Client.has_connection:
		pop_up.get_node("Label").text = "Failed to join server!";
		await get_tree().create_timer(3.0).timeout;
	pop_up.queue_free();
	print("closed");


func close_game():
	get_tree().quit();
