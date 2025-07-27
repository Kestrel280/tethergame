class_name Player_Flymode_Idle_State
extends Movement_State


static var state_name : StringName = "Player_Flymode_Idle_State";


func update_velocity(dt : float, wish_dir : Vector3, trying_jump : bool):
	wish_dir = Vector3(wish_dir.x, 0, wish_dir.z).normalized();
		
	# If trying to jump, just jump and transition to air state
	if trying_jump and body.is_on_floor():
		if trying_jump: do_jump(Player_Settings.jump_impulse);
		return Player_Flymode_Air_State.state_name;
	
	# Not doing anything at all
	if wish_dir == Vector3.ZERO: return Player_Flymode_Idle_State.state_name;
	
	# Doing something
	body.velocity += wish_dir * dt;
	return Player_Flymode_Walk_State.state_name;
	
