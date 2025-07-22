extends Movement_Controller


var wish_vel : Vector3;


func move(dt : float, wish_dir : Vector3):
	
	wish_vel = body.velocity;
	wish_dir = Vector3(wish_dir.x, 0, wish_dir.z).normalized();
	
	var new_state_name : StringName = movement_state_machine.current_state.try_move(dt, wish_dir, jumping);
	if new_state_name != movement_state_machine.current_state.state_name:
		movement_state_machine.transition(new_state_name);
	
	# Test movement without actually performing it
	# If we collided, do our own slide calculation first, before doing move_and_slide
	var collision = body.move_and_collide(body.velocity * dt, true);
	if collision: body.velocity = body.velocity.slide(collision.get_normal());
	
	body.move_and_slide();
