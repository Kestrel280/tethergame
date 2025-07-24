extends Level


func do_intro():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE);


func spawn_player(player : Player):
	player.queue_free();


func _on_play_pressed() -> void:
	MessageBus.change_level_requested.emit("test_level_1");


func _on_quit_pressed() -> void:
	MessageBus.quit_requested.emit();
