class_name Input_Controller_Kbm
extends Input_Controller_Base


func _input(event : InputEvent):
	super(event);
	if !enabled: return;
	if event is InputEventMouseMotion:
		var dt_x = event.relative.x * view_sensitivity / 750;
		var dt_y = event.relative.y * view_sensitivity / 750;
		incremental_rotation.x += dt_x;
		incremental_rotation.y += dt_y;
		changed_view.emit(Vector2(dt_x, dt_y));
