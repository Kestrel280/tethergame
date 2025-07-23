class_name Movement_Controller_Player_Alt
extends Movement_Controller_Base


static func construct() -> Variant:
	return preload("Movement_Controller_Player_Alt.tscn").instantiate();


func start(body : Node3D):
	super(body);
	assert(body is CharacterBody3D, "Movement_Controller_Player_Alt must be applied to a CharacterBody3D");
	
	for movement_state in $State_Machine.get_children():
		movement_state.start(body);
	
	# Determine initial state
	if !body.is_on_floor(): $State_Machine.current_state = $State_Machine/Player_Alt_Fly_State;
	else:
		if body.velocity.is_zero_approx(): $State_Machine.current_state = $State_Machine/Player_Alt_Idle_State;
		else: $State_Machine.current_state = $State_Machine/Player_Alt_Walk_State;


func move(dt : float, wish_dir : Vector3):
	var new_state_name : StringName = $State_Machine.current_state.update_velocity(dt, wish_dir, jumping);
	if new_state_name != $State_Machine.current_state.state_name:
		$State_Machine.transition(new_state_name);
	
	body.move_and_slide();


func get_current_move_state() -> StringName:
	return $State_Machine.current_state.state_name;
