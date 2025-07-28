class_name Player_Walk_State
extends Movement_State


static var state_name : StringName = "Player_Walk_State";


@warning_ignore("unused_parameter")
func update_velocity(dt : float, wish_dir : Vector3, trying_jump : bool) -> StringName:
	if !body.is_on_floor(): return Player_Air_State.state_name;
	
	wish_dir = Vector3(wish_dir.x, 0, wish_dir.z).normalized();
	
	# If trying to jump, just jump and transition to air state
	if trying_jump: 
		if trying_jump: do_jump(Player_Settings.jump_impulse);
		return Player_Air_State.state_name;
	
	# First apply friction
	var overspeed : float = max(body.velocity.length() - Player_Settings.max_ground_speed, 0.0);
	body.velocity = body.velocity.move_toward(Vector3.ZERO, Player_Settings.ground_friction * (1 + overspeed / Player_Settings.max_ground_speed));
	
	# Then apply input
	var cur_speed_in_wish_dir : float = body.velocity.dot(wish_dir);
	var max_add_speed : float = max(0.0, Player_Settings.max_ground_speed - cur_speed_in_wish_dir)
	var add_speed : float = clampf(Player_Settings.ground_accel * Player_Settings.max_ground_speed, 0, max_add_speed);
	body.velocity += add_speed * wish_dir;
	
	if body.velocity.is_zero_approx(): return Player_Idle_State.state_name;
	return Player_Walk_State.state_name;
