class_name Input_Controller
extends Resource


# Amount of x/y rotation since last fetched by rotation()
var _rot_x : float = 0.0;
var _rot_y : float = 0.0;


func input_dir_flat() -> Vector3:
	return Vector3.ZERO;


func jumping() -> bool:
	return false;


func incremental_rotation() -> Vector2:
	var x = _rot_x;
	var y = _rot_y;
	_rot_x = 0;
	_rot_y = 0;
	return Vector2(x, y);


func _init() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED);
