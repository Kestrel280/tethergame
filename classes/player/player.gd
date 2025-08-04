class_name Player
extends CharacterBody3D


var weapon : Weapon; # Currently equipped weapon


static func construct() -> Player:
	return preload("Player.tscn").instantiate();


func _ready() -> void:
	var head : Node3D = find_child("Head");
	var camera : Camera3D = head.find_child("Camera3D") if head else null;
	$Input_Controller.start(Player_Settings.kbm_sensitivity);
	install_input_controller($Input_Controller);
	$Camera_Controller.start(self, head, camera);
	$Movement_Controller.start(self);


@warning_ignore("unused_parameter")
func _process(delta : float) -> void:
	$Camera_Controller.add_rotation(-$Input_Controller.get_incremental_rotation());


func _physics_process(delta: float) -> void:
	$Movement_Controller.jumping = $Input_Controller.get_jumping();
	$Movement_Controller.move(delta, (self.transform.basis * $Head.transform.basis * $Input_Controller.get_input_dir()).normalized());
	
	Globals.debug_panel.add_property("position", "%3.2f, %3.2f, %3.2f" % [position.x, position.y, position.z]);
	Globals.debug_panel.add_property("velocity", "%3.2f, %3.2f, %3.2f" % [get_real_velocity().x, get_real_velocity().y, get_real_velocity().z]);
	Globals.debug_panel.add_property("xy_speed", "%3.2f" % Vector2(get_real_velocity().x, get_real_velocity().z).length());
	Globals.debug_panel.add_property("energy", "%3.2f" % (get_real_velocity().length_squared() / 2 + position.y * ProjectSettings.get_setting("physics/3d/default_gravity")));
	Globals.debug_panel.add_property("rotation", "%3.1f, %3.1f" % [rad_to_deg($Camera_Controller.rot.x), rad_to_deg($Camera_Controller.rot.y)]);
	Globals.debug_panel.add_property("movement_state", $Movement_Controller.get_current_move_state());


func swap_controller(new_controller : Controller_Base, delete_old_controller : bool = true) -> Node:
	var old_controller : Node = null;
	# Scan children for a controller of matching type
	# If there is one, remove it and return it
	# Then, install the new controller
	for child in get_children():
		if child is Controller_Base:
			if new_controller.get_controller_name() == child.get_controller_name():
				old_controller = child;
				remove_child(old_controller);
	add_child(new_controller);
	if new_controller is Input_Controller_Base: install_input_controller(new_controller);
	if delete_old_controller: old_controller.queue_free();
	return old_controller;


func equip_weapon(_weapon : Weapon):
	if weapon: weapon.abort_shoot();
	if weapon: weapon.queue_free();
	$Camera_Controller.get_head().add_child(_weapon);
	weapon = _weapon;


func on_input_controller_pressed_toggle_viewmode():
	var new_cc : Camera_Controller_Base;
	if $Camera_Controller is Camera_Controller_1st_Person: new_cc = Camera_Controller_3rd_Person.new();
	else: new_cc = Camera_Controller_1st_Person.new();
	new_cc.start(self, $Head, $Head/Camera3D, $Camera_Controller.rot);
	swap_controller(new_cc);


func on_input_controller_pressed_toggle_movemode():
	var new_mc : Movement_Controller_State_Machine;
	if $Movement_Controller.get_current_move_state().get_slice("_", 0) != "Player": return;
	if $Movement_Controller.get_current_move_state().split("_").has("Flymode"):
		new_mc = Movement_Controller_State_Machine.construct([Player_Idle_State.new(), Player_Walk_State.new(), Player_Air_State.new()]);
	else: new_mc = Movement_Controller_State_Machine.construct([Player_Flymode_Idle_State.new(), Player_Flymode_Walk_State.new(), Player_Flymode_Air_State.new()]);
	new_mc.start(self);
	swap_controller(new_mc);


func on_input_controller_pressed_change_weapon(weapon_num : int):
	match weapon_num:
		1: equip_weapon(Weapon.new(self, preload("res://weapons/pistol/pistol.tres")));
		2: equip_weapon(Weapon.new(self, preload("res://weapons/tether/tether.tres")));


func install_input_controller(ic : Input_Controller_Base):
	ic.pressed_toggle_viewmode.connect(on_input_controller_pressed_toggle_viewmode);
	ic.pressed_toggle_movemode.connect(on_input_controller_pressed_toggle_movemode);
	ic.pressed_change_weapon.connect(on_input_controller_pressed_change_weapon);
	ic.pressed_shoot.connect(func(): if weapon: weapon.try_shoot());
	ic.released_shoot.connect(func(): if weapon: weapon.stop_shoot());
