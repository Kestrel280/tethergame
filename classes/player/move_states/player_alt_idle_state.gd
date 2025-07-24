class_name Player_Alt_Idle_State
extends Movement_State


static var state_name : StringName = "Player_Alt_Idle_State";


func update_velocity(dt : float, wish_dir : Vector3, trying_jump : bool):
	wish_dir = Vector3(wish_dir.x, 0, wish_dir.z).normalized();
		
	# If trying to jump, just jump and transition to air state
	if trying_jump and body.is_on_floor():
		body.velocity.y = body.jump_impulse;
		return Player_Alt_Fly_State.state_name;
	
	# Not doing anything at all
	if wish_dir == Vector3.ZERO: return Player_Alt_Idle_State.state_name;
	
	# Doing something
	body.velocity += wish_dir * dt;
	return Player_Alt_Walk_State.state_name;
	
