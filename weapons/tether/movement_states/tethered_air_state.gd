class_name Tethered_Air_State
extends Movement_State


static var state_name : StringName = "Tethered_Air_State";
var perfect_angle_threshold : float = deg_to_rad(5); # Higher values = easier to hit a perfect tether
var catch_punish_exp : float = 1.5; # Higher values = higher punishment for bad tethers
var anchor_info : Anchor_Info;


func start(_body : CharacterBody3D):
	super(_body);
	anchor_info = _body.get_node("Tether_Anchor_Info");


@warning_ignore("unused_parameter")
func update_velocity(dt : float, wish_dir : Vector3, trying_jump : bool) -> StringName:
	if body.is_on_floor():
		
		# If we landed, but we're trying to jump, immediately re-jump and stay in airmove
		if trying_jump: do_jump(Player_Settings.jump_impulse);
		
		# If we landed, and our velocity is 0 now, go to idle
		elif body.velocity.is_zero_approx(): return Tethered_Idle_State.state_name;
		
		# If we landed, but we have velocity, go to walk
		else: return Tethered_Walk_State.state_name;
	
	# Test movement
	var wish_new_pos = body.global_position + body.velocity * dt;

	# If body is along the surface of the hook's sphere of influence:
	# (1) keep body from exceeding range of hook
	# (2) slide body's movement vector along the surface of the sphere
	# (3) apply speed adjustment factor which punishes rough landings and rewards smooth ones
	if wish_new_pos.distance_squared_to(anchor_info.anchor_point) > anchor_info.sqdist:
		var anchor_to_body_unit_vector = (body.position - anchor_info.anchor_point).normalized();
		var pre_slide_velocity : Vector3 = body.velocity;
		body.position = anchor_info.anchor_point + anchor_to_body_unit_vector * sqrt(anchor_info.sqdist); # (1)
		body.velocity = body.velocity.slide(anchor_to_body_unit_vector); # (2)
		var angle_of_impact : float = pre_slide_velocity.angle_to(body.velocity);
		var speed_adjust_ratio = 1.0 if angle_of_impact < perfect_angle_threshold else pow(cos(angle_of_impact), catch_punish_exp);
		if speed_adjust_ratio < 1.0: print("%.3f | %.5f" % [rad_to_deg(angle_of_impact), speed_adjust_ratio])
		body.velocity = body.velocity.normalized() * pre_slide_velocity.length() * speed_adjust_ratio;
	
	body.velocity += body.get_gravity() * dt;
	
	return self.state_name;
