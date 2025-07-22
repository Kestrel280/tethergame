extends Node


func _ready() -> void:
	# Connect signals
	MessageBus.change_level_requested.connect(change_level);
	MessageBus.player_requested_quit.connect(close_game);


func change_level(map_name : String):
	print(map_name);


func close_game():
	get_tree().quit();
