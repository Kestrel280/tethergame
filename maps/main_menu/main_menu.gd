extends Level


@warning_ignore("unused_parameter")
func _input(event : InputEvent):
	if Input.is_action_just_pressed("pause"): get_viewport().set_input_as_handled();


func do_intro():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE);


func spawn_player(player : Player):
	player.queue_free();


func _on_quit_pressed() -> void:
	Message_Bus.quit_requested.emit();


func _on_level_1_pressed() -> void:
	Message_Bus.change_level_requested.emit("test_level_1");


func _on_level_2_pressed() -> void:
	Message_Bus.change_level_requested.emit("test_level_2");


func _on_level_3_pressed() -> void:
	Message_Bus.change_level_requested.emit("test_level_3");


func _on_level_4_pressed() -> void:
	Message_Bus.change_level_requested.emit("test_level_4");


func _on_level_5_pressed() -> void:
	Message_Bus.change_level_requested.emit("test_level_5");


func _on_level_6_pressed() -> void:
	Message_Bus.change_level_requested.emit("test_level_6");
