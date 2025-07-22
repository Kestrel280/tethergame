extends Movement_Controller


var wish_vel : Vector3;


func move(dt : float, wish_dir : Vector3):
	
	wish_vel = body.velocity;
	wish_dir = Vector3(wish_dir.x, 0, wish_dir.z).normalized();
	
	var new_state_name : StringName = movement_state_machine.current_state.try_move(dt, wish_dir, jumping);
	if new_state_name != movement_state_machine.current_state.state_name:
		movement_state_machine.transition(new_state_name);

	body.move_and_slide();
