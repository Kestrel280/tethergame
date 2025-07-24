class_name Player_Alt_Fly_State
extends Movement_State


static var state_name : StringName = "Player_Alt_Fly_State";


func update_velocity(dt : float, wish_dir : Vector3, jumping : bool) -> StringName:
	if body.is_on_floor():
		# If we landed, and our velocity is 0 now, go to idle
		if body.velocity.is_zero_approx(): return Player_Idle_State.state_name;
		
		# If we landed, but we have velocity, go to walk
		else: return Player_Alt_Walk_State.state_name;
	
	if wish_dir:
		body.velocity = lerp(body.velocity, wish_dir * body.max_ground_speed * 5.0, body.ground_accel / 2.0);
	else:
		body.velocity = lerp(body.velocity, Vector3.ZERO, body.ground_friction / 2.0);
		if body.velocity.is_zero_approx(): return Player_Alt_Idle_State.state_name;
	
	
	return self.state_name;
