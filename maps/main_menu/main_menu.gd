extends Level


func _on_play_pressed() -> void:
	MessageBus.change_level_requested.emit("test_level_1");


func _on_quit_pressed() -> void:
	MessageBus.quit_requested.emit();
