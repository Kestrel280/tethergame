class_name Input_Controller_Kbm
extends Input_Controller_Base


func handle_input_impl(event) -> void:
	if event is InputEventMouseMotion:
		_rot.x += event.relative.x * sensitivity;
		_rot.y += event.relative.y * sensitivity;
		_rot = _rot * 2 / ProjectSettings.get_setting("display/window/size/viewport_width");
	elif event is InputEventKey:
		if Input.is_action_just_pressed("pause"):
			Message_Bus.pause_requested.emit();


func input_dir_raw_impl() -> Vector3:
	var input_2d = Input.get_vector("move_left", "move_right", "move_forward", "move_backward");
	return Vector3(input_2d.x, 0, input_2d.y).normalized();


func is_trying_jump() -> bool:
	return Input.is_action_pressed("jump");
