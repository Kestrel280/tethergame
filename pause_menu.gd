extends Tether_Ui


var stored_mouse_mode : Input.MouseMode;


func _input(event):
	if Input.is_action_just_pressed("pause"):
		unpause();


func _ready():
	stored_mouse_mode = Input.get_mouse_mode();
	get_tree().call_group("input_controllers", "disable");
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE);
	


func unpause():
	get_tree().call_group("input_controllers", "enable");
	Input.set_mouse_mode(stored_mouse_mode);
	queue_free();


func _on_button_resume_pressed() -> void:
	unpause();


func _on_button_main_menu_pressed() -> void:
	unpause();
	Message_Bus.change_level_requested.emit("main_menu");


func _on_button_quit_pressed() -> void:
	Message_Bus.quit_requested.emit();
