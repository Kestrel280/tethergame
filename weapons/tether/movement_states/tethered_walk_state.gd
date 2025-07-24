class_name Tethered_Walk_State
extends Movement_State


static var state_name : StringName = "Tethered_Walk_State";


func update_velocity(dt : float, wish_dir : Vector3, trying_jump : bool) -> StringName:
	if !body.is_on_floor(): return Tethered_Air_State.state_name;
	
	# If trying to jump, just jump and transition to air state
	if trying_jump: 
		do_jump();
		return Tethered_Air_State.state_name;
	
	# If we're actually trying to walk, bypass friction
	if wish_dir:
		body.velocity.x = lerp(body.velocity.x, wish_dir.x * body.max_ground_speed, body.ground_accel);
		body.velocity.z = lerp(body.velocity.z, wish_dir.z * body.max_ground_speed, body.ground_accel);
	else:
		body.velocity = body.velocity.move_toward(Vector3.ZERO, body.ground_friction);
		if body.velocity.is_zero_approx(): return Tethered_Idle_State.state_name;
	return Tethered_Walk_State.state_name;
	
