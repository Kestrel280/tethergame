class_name Input_Controller_Remote
extends Input_Controller_Base


func _input(event : InputEvent):
	pass;


func get_jumping() -> bool: return false;
func get_crouching() -> bool: return false;
func get_input_dir() -> Vector3:
	return Vector3.ZERO;
