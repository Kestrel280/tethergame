class_name Player_Air_State
extends Movement_State


static var state_name : StringName = "Player_Air_State";


func update_velocity(dt : float, wish_dir : Vector3, trying_jump : bool) -> StringName:
	if body.is_on_floor():
		
		# If we landed, but we're trying to jump, immediately re-jump and stay in airmove
		if trying_jump: do_jump(Player_Settings.jump_impulse);
		
		# If we landed, and our velocity is 0 now, go to idle
		elif body.velocity.is_zero_approx(): return Player_Idle_State.state_name;
		
		# If we landed, but we have velocity, go to walk
		else: return Player_Walk_State.state_name;
	
	wish_dir = Vector3(wish_dir.x, 0, wish_dir.z).normalized();
	var cur_speed_in_wish_dir = wish_dir.dot(body.velocity);
	var max_speed_to_add = max(0, Player_Settings.air_speed_cap - cur_speed_in_wish_dir);
	var speed_to_add_in_wish_dir = clampf(Player_Settings.air_accel * Player_Settings.air_speed_cap * dt, 0.0, max_speed_to_add);
	body.velocity += speed_to_add_in_wish_dir * wish_dir;
	body.velocity += body.get_gravity() * dt;
	return self.state_name;
