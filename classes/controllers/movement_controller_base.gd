class_name Movement_Controller_Base
extends Controller_Base


## Movement controllers must define a move(dt : float) function,
## which updates the location of the body it is controlling (set via start()).
## They should also define a get_current_move_state()->StringName function,
## but it is not strictly necessary.

@warning_ignore("unused_signal")
signal movement_state_changed(new_state : StringName);


var jumping : bool;
var aux : Dictionary = {};


# Users of the component must set this!
var body : CharacterBody3D;


# Don't override these, or at least call super()
func get_controller_name():
	return "Movement_Controller";


func start(_body : Node3D, _aux : Dictionary = {}):
	body = _body;
	aux = _aux;


func set_jumping(j : bool):
	jumping = j;


# Override these
@warning_ignore_start("unused_parameter")
func move(dt : float, wish_dir : Vector3):
	pass;


func get_current_move_state() -> StringName:
	return "Unknown_Move_State";
@warning_ignore_restore("unused_parameter")
