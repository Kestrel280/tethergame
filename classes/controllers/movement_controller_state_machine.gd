class_name Movement_Controller_State_Machine
extends Movement_Controller_Base


@export var default_idle_state : Movement_State;
@export var default_ground_state : Movement_State;
@export var default_air_state : Movement_State;


# AIO, construct a new Movement_Controller_State_Machine.
# states[0] -> default idle state; states[1] -> default ground state; states[2] default air state.
static func construct(states : Array[Movement_State]) -> Movement_Controller_State_Machine:	
	assert(states.size() > 0, "Movement_Controller_State_Machine cannot be constructed with 0 states");
	var me = Movement_Controller_State_Machine.new();
	var sm = State_Machine.new();
	me.name = "Movement_Controller";
	sm.name = "State_Machine";
	me.add_child(sm);
	for state in states:
		state.name = state.state_name;
		sm.add_child(state);
	me.default_idle_state = states[0];
	if states.size() > 0: me.default_ground_state = states[1];
	if states.size() > 1: me.default_air_state = states[2];
	return me;


func start(body : Node3D):
	super(body);
	assert(body is CharacterBody3D, "Movement_Controller_Player must be applied to a CharacterBody3D");
	
	for movement_state in $State_Machine.get_children():
		movement_state.start(body);
	
	# Determine initial state
	if !body.is_on_floor(): $State_Machine.current_state = default_air_state;
	else:
		if body.velocity.is_zero_approx(): $State_Machine.current_state = default_idle_state;
		else: $State_Machine.current_state = default_ground_state;


func move(dt : float, wish_dir : Vector3):
	var new_state_name : StringName = $State_Machine.current_state.update_velocity(dt, wish_dir, jumping);
	if new_state_name != $State_Machine.current_state.state_name:
		$State_Machine.transition(new_state_name);
	
	# Test movement without actually performing it
	# If we collided, do our own slide calculation first, before doing move_and_slide
	var collision = body.move_and_collide(body.velocity * dt, true);
	if collision:
		Globals.debug_panel.add_property("last_collision_inclination", "%.2f" % rad_to_deg(acos(collision.get_normal().y)));
		if acos(collision.get_normal().y) < body.floor_max_angle: body.apply_floor_snap();
		else: body.velocity = body.velocity.slide(collision.get_normal());
	
	body.move_and_slide();


func get_current_move_state() -> StringName:
	return $State_Machine.current_state.state_name;
