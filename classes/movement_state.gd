class_name Movement_State
extends State


@export var body : CharacterBody3D;


func _ready():
	if !body: body = get_owner();
	await body.ready;


# Should update 'velocity' of body and return a state name.
func try_move(dt : float, wish_dir : Vector3, trying_jump : bool) -> StringName:
	return "";
	pass;
