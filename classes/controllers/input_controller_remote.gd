class_name Input_Controller_Remote
extends Input_Controller_Base


var connected : bool = false;
var jumping : bool = false;
var crouching : bool = false;
var input_dir : Vector3 = Vector3.ZERO;
var inc_rot : Vector2 = Vector2.ZERO;
var shooting : bool = false;
var interacting : bool = false;


func inject(_input_dir : Vector3, _jumping : bool, _crouching : bool, _shooting : bool, _interacting : bool):
	if _jumping != jumping:
		if _jumping: pressed_jump.emit();
		jumping = _jumping;
	if _crouching != crouching:
		if _crouching: pressed_crouch.emit();
		crouching = _crouching;
	if _shooting != shooting:
		if _shooting: pressed_shoot.emit();
		else: released_shoot.emit();
		shooting = _shooting;
	if _interacting != interacting:
		pressed_interact.emit();
		interacting = _interacting;
	input_dir = _input_dir;


func _input(event : InputEvent): pass;
func get_jumping() -> bool: return jumping;
func get_crouching() -> bool: return crouching;
func get_input_dir() -> Vector3: return input_dir;
func get_incremental_rotation() -> Vector2: return inc_rot;
