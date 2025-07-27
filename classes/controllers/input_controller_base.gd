class_name Input_Controller_Base
extends Controller_Base


# Amount of x/y rotation since last fetched by incremental_rotation()
var _rot : Vector2 = Vector2.ZERO;

# Whether or not the controller is currently enabled
# (For example, when paused, we probably want to disable any active input controllers)
var enabled : bool = true;


# Don't override these; if you MUST, make sure to call super()
func _ready():
	super();
	add_to_group("input_controllers");


func get_controller_name():
	return "Input_Controller";


func incremental_rotation() -> Vector2:
	var inc = _rot;
	_rot = Vector2.ZERO;
	return inc;


func enable():
	enabled = true;
func disable():
	enabled = false;


func handle_input(event):
	if !enabled: return;
	handle_input_impl(event);


func input_dir_raw() -> Vector3:
	if !enabled: return Vector3.ZERO;
	return input_dir_raw_impl();


# Override these
func handle_input_impl(event):
	pass;


func input_dir_raw_impl() -> Vector3:
	return Vector3.ZERO;


func is_trying_jump() -> bool:
	return false;
