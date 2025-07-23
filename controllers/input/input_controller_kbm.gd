extends Input_Controller


@export_range(1.0, 25.0) var sensitivity : float = 4.0;


func handle_input(event) -> void:
	if event is InputEventMouseMotion:
		_rot_x += event.relative.x;
		_rot_y += event.relative.y;


func input_dir_raw() -> Vector3:
	var input_2d = Input.get_vector("move_left", "move_right", "move_forward", "move_backward");
	return Vector3(input_2d.x, 0, input_2d.y).normalized();


func is_trying_jump() -> bool:
	return Input.is_action_pressed("jump");


func _init() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED);
