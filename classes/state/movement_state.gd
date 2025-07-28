class_name Movement_State
extends State


@export var body : CharacterBody3D;


func start(_body : CharacterBody3D):
	self.body = _body;


# Should update 'velocity' of body and return a state name.
@warning_ignore("unused_parameter")
func update_velocity(dt : float, wish_dir : Vector3, trying_jump : bool) -> StringName:
	return "";


func do_jump(jump_impulse : float):
	body.velocity.y = jump_impulse;
