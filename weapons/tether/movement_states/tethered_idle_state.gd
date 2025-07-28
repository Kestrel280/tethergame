class_name Tethered_Idle_State
extends Movement_State


static var state_name : StringName = "Tethered_Idle_State";
var anchor_info : Anchor_Info;


func start(_body : CharacterBody3D):
	super(_body);
	anchor_info = _body.get_node("Tether_Anchor_Info");


func update_velocity(dt : float, wish_dir : Vector3, trying_jump : bool) -> StringName:
	# If we slipped off the floor somehow (we're in idle, so the floor must've been pulled from under us), transition to air state
	if !body.is_on_floor(): return Tethered_Air_State.state_name;
	
	# If trying to jump, just jump and transition to air state
	if trying_jump: 
		body.velocity.y = Player_Settings.jump_impulse;
		return Tethered_Air_State.state_name;
	
	# We have some velocity; could happen if we enter this state machine from another, for example
	if !body.velocity.is_equal_approx(Vector3.ZERO):
		return Tethered_Walk_State.state_name;
	
	# Not doing anything at all
	if wish_dir == Vector3.ZERO: return Tethered_Idle_State.state_name;
	
	# Doing something
	body.velocity += wish_dir  * dt;
	return Tethered_Walk_State.state_name;
