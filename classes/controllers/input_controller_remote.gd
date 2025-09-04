class_name Input_Controller_Remote
extends Input_Controller_Base


var connected : bool = false;
var jumping : bool = false;
var crouching : bool = false;
var input_dir : Vector3 = Vector3.ZERO;
var inc_rot : Vector2 = Vector2.ZERO;


func _input(event : InputEvent): pass;
func get_jumping() -> bool: return jumping;
func get_crouching() -> bool: return crouching;
func get_input_dir() -> Vector3: return input_dir;
func get_incremental_rotation() -> Vector2: return inc_rot;
