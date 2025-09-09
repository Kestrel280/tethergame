class_name Movement_State
extends State


# Movement states can access a "last_velocity" metadata attribute of their controlling state machine,
# which is set by the ancestor Movement_Controller_State_Machine.
# It contains the velocity of the body which was used for last frame's movement.


var body : CharacterBody3D;


func start(_body : CharacterBody3D):
	body = _body;


# Should update 'velocity' of body and return a state name.
func update_velocity(_dt : float, _wish_dir : Vector3, _trying_jump : bool) -> StringName:
	return "";


func do_jump(jump_impulse : float):
	body.velocity.y = jump_impulse;
