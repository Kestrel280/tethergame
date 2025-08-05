class_name Input_Controller_Base
extends Controller_Base


@warning_ignore_start("unused_signal")
signal pressed_jump;
signal pressed_crouch;
signal pressed_shoot;
signal released_shoot;
signal pressed_interact;
signal pressed_change_weapon(weapon_type : int);
signal pressed_toggle_movemode(movemode : int);
signal pressed_toggle_viewmode(viewmode : int);
signal changed_view(dt_rot : Vector2);
@warning_ignore_restore("unused_signal")


@warning_ignore("unused_parameter")
func _input(event : InputEvent):
	if !enabled: return;
	# Not if/elif's, because actions might be bound to the same keys
	if Input.is_action_just_pressed("jump"): pressed_jump.emit();
	if Input.is_action_just_pressed("crouch"): pressed_crouch.emit();
	if Input.is_action_just_pressed("shoot"): pressed_shoot.emit();
	if Input.is_action_just_released("shoot"): released_shoot.emit();
	if Input.is_action_just_pressed("interact"): pressed_interact.emit();
	if Input.is_action_just_pressed("equip_weapon_1"): pressed_change_weapon.emit(1);
	if Input.is_action_just_pressed("equip_weapon_2"): pressed_change_weapon.emit(2);
	if Input.is_action_just_pressed("toggle_movemode"): pressed_toggle_movemode.emit();
	if Input.is_action_just_pressed("toggle_viewmode"): pressed_toggle_viewmode.emit();



var incremental_rotation : Vector2 = Vector2.ZERO; # Amount of x/y rotation since last fetched by get_incremental_rotation()
var enabled : bool = true; # Whether or not the controller is currently enabled (input controllers are disabled while paused)


# Don't override these, or at least call super()
func _ready():
	super();
	add_to_group("input_controllers");
func get_controller_name() -> StringName: return "Input_Controller";
func enable(): enabled = true;
func disable(): enabled = false;
func get_jumping() -> bool: return Input.is_action_pressed("jump");
func get_crouching() -> bool: return Input.is_action_pressed("crouch");
func get_incremental_rotation() -> Vector2:
	var ret = incremental_rotation;
	incremental_rotation = Vector2.ZERO;
	return ret;
func get_input_dir() -> Vector3:
	if !enabled: return Vector3.ZERO;
	var input_dir_2d = Input.get_vector("move_left", "move_right", "move_forward", "move_backward");
	var ret = Vector3(input_dir_2d.x, 0.0, input_dir_2d.y);
	return ret;
