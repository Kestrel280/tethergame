class_name Tethered_Air_State
extends Movement_State


static var state_name : StringName = "Tethered_Air_State";
var perfect_angle_threshold : float = deg_to_rad(5); # Higher values = easier to hit a perfect tether
var catch_forgiveness_curve_exp : float = 0.5; # Higher values = less punishment for bad tethers


func start(_body : CharacterBody3D):
	super(_body);


@warning_ignore("unused_parameter")
func update_velocity(dt : float, wish_dir : Vector3, trying_jump : bool) -> StringName:
	# If we're on the floor this frame, first "bounce" along the floor. Then, multiple cases:
	#	Slidemove if our projected velocity has a y component greater than our jump impulse
	#	OR, if we're jumping, immediately rejump
	#	OR, if we have no velocity, transition to idle
	#	OR, if we have some velocity, transition to walk
	if body.is_on_floor():
		var floor_projected_velocity = body.velocity.slide(body.get_floor_normal());
		body.velocity = sm.get_meta("last_velocity").bounce(body.get_floor_normal());
		body.velocity.y = 0;

		if floor_projected_velocity.y > Player_Settings.jump_impulse: body.velocity = floor_projected_velocity; # Slidemove
		elif trying_jump: do_jump(Player_Settings.jump_impulse); # Immediate re-jump
		elif body.velocity.is_zero_approx(): return Tethered_Idle_State.state_name; # Go idle
		else: return Tethered_Walk_State.state_name; # Go to walk
	
	# Test movement
	var wish_new_pos = body.global_position + body.velocity * dt;
	
	# Keep the player inside the hook's sphere of influence, and adjust their velocity to align.
	# When the body tugs against the boundary of the hook's sphere of influence,
	#	we slide the velocity along the normal plane at the point on the sphere.
	#	The "impact angle" A affects the magnitude of the resulting velocity:
	#	||v1|| == ||v0|| * cos(A)  ... This feels a little too punishing.
	#	To be 100% forgiving, can re-adjust the magnitude by dividing by cos(A)... too forgiving!!!
	#	So, we can scale the re-adjustment factor by some exponent to tweak the forgiveness curve:
	#	https://www.desmos.com/calculator/ffhc9gxagx
	#	Values less than 0 are extra punishing; exactly 0 is pure/unfiltered; 0-1 is forgiveness %.
	#	(Ultimately: speed adjustment factor when hitting sphere is cos(A)^(1-catch_punish_exp))
	#	For angles of impact less than perfect_angle_threshold, we give maximum forgiveness
	#		(that is, divide by cos(A); or set p == 1.0; they're equivalent).
	if wish_new_pos.distance_squared_to(sm.aux["anchor_position"]) > sm.aux["anchor_sqdist"]:
		var anchor_to_body_unit_vector = (body.position - sm.aux["anchor_position"]).normalized();
		var angle_of_impact : float = PI/2 - acos(body.velocity.normalized().dot(anchor_to_body_unit_vector)); # (0.1)
		var speed_loss_factor : float;
		if angle_of_impact > deg_to_rad(perfect_angle_threshold): speed_loss_factor = cos(angle_of_impact);
		body.position = sm.aux["anchor_position"] + anchor_to_body_unit_vector * sqrt(sm.aux["anchor_sqdist"]); # (1)
		body.velocity = body.velocity.slide(anchor_to_body_unit_vector); # (2)
		var speed_adjust_ratio = pow(cos(angle_of_impact), catch_forgiveness_curve_exp);
		body.velocity /= pow(cos(angle_of_impact), catch_forgiveness_curve_exp if angle_of_impact > perfect_angle_threshold else 1.0);
	
	body.velocity += body.get_gravity() * dt;
	
	return self.state_name;
