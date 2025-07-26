class_name Input_Controller_Kbm
extends Input_Controller_Base


@export_range(0.5, 5.0) var sensitivity : float = 1.8;


func handle_input(event) -> void:
	if event is InputEventMouseMotion:
		_rot_x += event.relative.x * sensitivity;
		_rot_y += event.relative.y * sensitivity;


func input_dir_raw() -> Vector3:
	var input_2d = Input.get_vector("move_left", "move_right", "move_forward", "move_backward");
	return Vector3(input_2d.x, 0, input_2d.y).normalized();


func is_trying_jump() -> bool:
	return Input.is_action_pressed("jump");
