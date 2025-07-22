class_name Player_Idle_State
extends Movement_State


static var state_name : StringName = "Player_Idle_State";


func try_move(dt : float, wish_dir : Vector3, trying_jump : bool) -> StringName:
	if wish_dir == Vector3.ZERO: return Player_Idle_State.state_name;
	
	body.velocity += wish_dir * dt;
	return Player_Walk_State.state_name;
	
