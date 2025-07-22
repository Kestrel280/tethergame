class_name Player_Air_State
extends Movement_State


static var state_name : StringName = "Player_Air_State";


func try_move(dt : float, wish_dir : Vector3, trying_jump : bool) -> StringName:
	if body.is_on_floor():
		if body.velocity.is_zero_approx(): return Player_Idle_State.state_name;
		else: return Player_Walk_State.state_name;
	body.velocity += body.get_gravity() * dt;
	return self.state_name;
