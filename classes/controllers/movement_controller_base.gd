class_name Movement_Controller_Base
extends Controller_Base


## Movement controllers must define a move(dt : float) function,
## which updates the location of the body it is controlling (set via start()).
## They should also define a get_current_move_state()->StringName function,
## but it is not strictly necessary.

signal movement_state_changed(new_state : StringName);


var jumping : bool;


# Users of the component must set this!
var body : CharacterBody3D;


# Don't override these
func get_controller_name():
	return "Movement_Controller";


func start(body : Node3D):
	self.body = body;


func set_jumping(j : bool):
	jumping = j;


# Override these
func move(dt : float, wish_dir : Vector3):
	pass;


func get_current_move_state() -> StringName:
	return "Unknown_Move_State";
