class_name Player_Walk_State
extends Movement_State


static var state_name : StringName = "Player_Walk_State";

var max_ground_speed : float;
var ground_accel : float;
var ground_friction : float;

func _ready() -> void:
	super();
	max_ground_speed = body.max_ground_speed;
	ground_accel = body.ground_accel;
	ground_friction = body.ground_friction;

func try_move(dt : float, wish_dir : Vector3, trying_jump : bool) -> StringName:

	var wish_vel : Vector3 = body.velocity;
	
	if !body.is_on_floor():
		return Player_Air_State.state_name;
	
	# If trying to jump, just jump and transition to air state
	if trying_jump: 
		body.velocity.y = body.jump_impulse;
		return Player_Air_State.state_name;
	
	# If we're actually trying to walk, bypass friction
	if wish_dir:
		body.velocity.x = lerp(body.velocity.x, wish_dir.x * max_ground_speed, ground_accel);
		body.velocity.z = lerp(body.velocity.z, wish_dir.z * max_ground_speed, ground_accel);
	else:
		body.velocity = body.velocity.move_toward(Vector3.ZERO, ground_friction);
		if body.velocity.is_zero_approx(): return Player_Idle_State.state_name;
	return Player_Walk_State.state_name;
	
