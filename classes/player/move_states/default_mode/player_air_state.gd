class_name Player_Air_State
extends Movement_State


static var state_name : StringName = "Player_Air_State";


func update_velocity(dt : float, wish_dir : Vector3, trying_jump : bool) -> StringName:
	# If we're on the floor this frame, first "bounce" along the floor. Then, multiple cases:
	#	Slidemove if our projected velocity has a y component greater than our jump impulse
	#	OR, if we're jumping, immediately rejump
	#	OR, if we have no velocity, transition to idle
	#	OR, if we have some velocity, transition to walk
	if body.is_on_floor():
		var floor_projected_velocity = body.velocity.slide(body.get_floor_normal());
		body.velocity = sm.get_meta("last_velocity").bounce(body.get_floor_normal());
		body.velocity.y = 0;

		if floor_projected_velocity.y > Player_Settings.jump_impulse: body.velocity = floor_projected_velocity; # Slidemove
		elif trying_jump: do_jump(Player_Settings.jump_impulse); # Immediate re-jump
		elif body.velocity.is_zero_approx(): return Player_Idle_State.state_name; # Go idle
		else: return Player_Walk_State.state_name; # Go to walk
	
	wish_dir = Vector3(wish_dir.x, 0, wish_dir.z).normalized();
	var cur_speed_in_wish_dir = wish_dir.dot(body.velocity);
	var max_speed_to_add = max(0, Player_Settings.air_speed_cap - cur_speed_in_wish_dir);
	var speed_to_add_in_wish_dir = clampf(Player_Settings.air_accel * Player_Settings.air_speed_cap * dt, 0.0, max_speed_to_add);
	body.velocity += speed_to_add_in_wish_dir * wish_dir;
	body.velocity += body.get_gravity() * dt;
	return self.state_name;
