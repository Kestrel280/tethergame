class_name Input_Controller_Kbm
extends Input_Controller_Base


func _input(event : InputEvent):
	super(event);
	if !enabled: return;
	if event is InputEventMouseMotion:
		# If just using raw event.relative value, 1 pixel = 1 radian
		# Scale down s.t. 1 pixel = 0.00000033 radians; still well above any floating point issues
		# Then rescale up according to window size
		# Finally, apply user sensitivity
		var dt : Vector2 = Vector2(event.relative.x, event.relative.y);
		dt *= 0.00000033;
		dt *= Vector2(get_window().size);
		dt *= Player_Settings.kbm_sensitivity;
		incremental_rotation += dt;
		changed_view.emit(dt);
		# print("%2.4f | %.8f, %10.2f" % [event.relative.x, dt.x, event.relative.x / dt.x]);
