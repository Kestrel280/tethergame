extends Control


var stored_mouse_mode : Input.MouseMode;


@warning_ignore("unused_parameter")
func _input(event : InputEvent):
	if Input.is_action_just_pressed("pause"):
		unpause();
		get_viewport().set_input_as_handled();


func _ready():
	stored_mouse_mode = Input.get_mouse_mode();
	get_tree().call_group("input_controllers", "disable");
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE);
	print(Player_Settings.kbm_sensitivity);
	$Center_Screen/Sensitivity_Container/Sensitivity_Slider.value = Player_Settings.kbm_sensitivity;
	$Center_Screen/Sensitivity_Container/Sensitivity_Slider/Sensitivity_Input.value = Player_Settings.kbm_sensitivity;


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


func _on_sensitivity_slider_value_changed(value: float) -> void:
	$Center_Screen/Sensitivity_Container/Sensitivity_Slider/Sensitivity_Input.set_value_no_signal(value);
	Player_Settings.kbm_sensitivity = value;


func _on_sensitivity_input_value_changed(value: float) -> void:
	$Center_Screen/Sensitivity_Container/Sensitivity_Slider.set_value_no_signal(value);
	Player_Settings.kbm_sensitivity = value;
