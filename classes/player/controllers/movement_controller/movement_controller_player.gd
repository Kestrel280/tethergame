class_name Movement_Controller_Player
extends Movement_Controller_Base


var wish_vel : Vector3;


static func construct() -> Movement_Controller_Player:
	return preload("Movement_Controller_Player.tscn").instantiate();


func start(body : Node3D):
	super(body);
	assert(body is CharacterBody3D, "Movement_Controller_Player must be applied to a CharacterBody3D");
	
	for movement_state in $State_Machine.get_children():
		movement_state.start(body);
	
	# Determine initial state
	if !body.is_on_floor(): $State_Machine.current_state = $State_Machine/Player_Air_State;
	else:
		if body.velocity.is_zero_approx(): $State_Machine.current_state = $State_Machine/Player_Idle_State;
		else: $State_Machine.current_state = $State_Machine/Player_Walk_State;


func move(dt : float, wish_dir : Vector3):
	wish_vel = body.velocity;
	wish_dir = Vector3(wish_dir.x, 0, wish_dir.z).normalized();
	
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
	
	body.velocity += body.get_gravity() * dt;
	body.move_and_slide();


func get_current_move_state() -> StringName:
	return $State_Machine.current_state.state_name;
