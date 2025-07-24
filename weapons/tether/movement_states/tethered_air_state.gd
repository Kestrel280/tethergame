class_name Tethered_Air_State
extends Movement_State


static var state_name : StringName = "Tethered_Air_State";
var anchor_info : Anchor_Info;


func start(body : CharacterBody3D):
	super(body);
	anchor_info = body.get_node("Tether_Anchor_Info");


func update_velocity(dt : float, wish_dir : Vector3, trying_jump : bool) -> StringName:
	if body.is_on_floor():
		
		# If we landed, but we're trying to jump, immediately re-jump and stay in airmove
		if trying_jump: do_jump();
		
		# If we landed, and our velocity is 0 now, go to idle
		elif body.velocity.is_zero_approx(): return Tethered_Idle_State.state_name;
		
		# If we landed, but we have velocity, go to walk
		else: return Tethered_Walk_State.state_name;
	
	body.velocity += body.get_gravity() * dt;
	
	# If body is along the surface of the hook's sphere of influence:
	# (1) keep body from exceeding range of hook
	# (2) slide body's movement vector along the surface of the sphere
	# (3) if sliding smoothly along the sphere, apply adjustment factor to preserve speed 
	if body.position.distance_squared_to(anchor_info.anchor_point) > anchor_info.sqdist:
		var anchor_to_body_unit_vector = (body.position - anchor_info.anchor_point).normalized();
		var sq_pre_adjust_speed = body.velocity.length_squared();
		body.position = anchor_info.anchor_point + anchor_to_body_unit_vector * sqrt(anchor_info.sqdist); # (1)
		body.velocity = body.velocity.slide(anchor_to_body_unit_vector); # (2)
		var sq_speed_loss_ratio = body.velocity.length_squared() / sq_pre_adjust_speed;
		if sq_speed_loss_ratio > 0.9: body.velocity /= sqrt(sq_speed_loss_ratio); # (3)
	return self.state_name;
