class_name Tethered_Idle_State
extends Movement_State


static var state_name : StringName = "Tethered_Idle_State";


func update_velocity(dt : float, wish_dir : Vector3, trying_jump : bool) -> StringName:
	# If we slipped off the floor somehow (we're in idle, so the floor must've been pulled from under us), transition to air state
	if !body.is_on_floor(): return Tethered_Air_State.state_name;
	
	# If trying to jump, just jump and transition to air state
	if trying_jump: 
		body.velocity.y = body.jump_impulse;
		return Tethered_Air_State.state_name;
	
	# Not doing anything at all
	if wish_dir == Vector3.ZERO: return Tethered_Idle_State.state_name;
	
	# Doing something
	body.velocity += wish_dir  * dt;
	return Tethered_Walk_State.state_name;
