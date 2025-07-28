class_name Player_Flymode_Air_State
extends Movement_State


static var state_name : StringName = "Player_Flymode_Air_State";


func update_velocity(dt : float, wish_dir : Vector3, jumping : bool) -> StringName:
	if body.is_on_floor():
		# If we landed, and our velocity is 0 now, go to idle
		if body.velocity.is_zero_approx(): return Player_Flymode_Idle_State.state_name;
		
		# If we landed, but we have velocity, go to walk
		else: return Player_Flymode_Walk_State.state_name;
	
	if wish_dir:
		body.velocity = lerp(body.velocity, wish_dir * Player_Settings.max_ground_speed * 15.0, Player_Settings.ground_accel / 2.0);
	else:
		body.velocity = lerp(body.velocity, Vector3.ZERO, Player_Settings.ground_friction / 2.0);
		if body.velocity.is_zero_approx(): return Player_Flymode_Idle_State.state_name;
	
	
	return self.state_name;
