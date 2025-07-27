class_name Player
extends CharacterBody3D


var weapon : Weapon; # Currently equipped weapon


static func construct() -> Player:
	return preload("Player.tscn").instantiate();


func _ready() -> void:
	var head : Node3D = find_child("Head");
	var camera : Camera3D = head.find_child("Camera3D") if head else null;
	$Camera_Controller.start(self, head, camera);
	$Movement_Controller.start(self);


# TODO all of this is temporary/debug, needs to be moved to appropriate spots
func _input(event) -> void:
	$Input_Controller.handle_input(event);
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_Q:
			var test = Movement_Controller_State_Machine.construct([Player_Idle_State.new(), Player_Walk_State.new(), Player_Air_State.new()]);
			test.start(self);
			swap_controller(test);
		elif event.pressed and event.keycode == KEY_E:
			var test = Movement_Controller_State_Machine.construct([Player_Flymode_Idle_State.new(), Player_Flymode_Walk_State.new(), Player_Flymode_Air_State.new()]);
			test.start(self);
			swap_controller(test);
		elif event.pressed and event.keycode == KEY_Z:
			var test = Camera_Controller_3rd_Person.new();
			test.start(self, $Head, $Head/Camera3D, $Camera_Controller.rot);
			swap_controller(test);
		elif event.pressed and event.keycode == KEY_C:
			var test = Camera_Controller_1st_Person.new();
			test.start(self, $Head, $Head/Camera3D, $Camera_Controller.rot);
			swap_controller(test);
		elif event.pressed and event.keycode == KEY_1:
			equip_weapon(Weapon.new(self, preload("res://weapons/pistol/pistol.tres")));
		elif event.pressed and event.keycode == KEY_2:
			equip_weapon(Weapon.new(self, preload("res://weapons/tether/tether.tres")));
	elif Input.is_action_just_pressed("shoot"):
		if weapon: weapon.try_shoot();
	elif Input.is_action_just_released("shoot"):
		if weapon: weapon.stop_shoot();


func _physics_process(delta: float) -> void:
	$Camera_Controller.add_rotation(-$Input_Controller.incremental_rotation());
	$Movement_Controller.jumping = $Input_Controller.is_trying_jump();
	$Movement_Controller.move(delta, (self.transform.basis * $Head.transform.basis *  $Input_Controller.input_dir_raw()).normalized());
	
	Globals.debug_panel.add_property("position", "%3.2f, %3.2f, %3.2f" % [position.x, position.y, position.z]);
	Globals.debug_panel.add_property("velocity", "%3.2f, %3.2f, %3.2f" % [get_real_velocity().x, get_real_velocity().y, get_real_velocity().z]);
	Globals.debug_panel.add_property("xy_speed", "%3.2f" % Vector2(get_real_velocity().x, get_real_velocity().z).length());
	Globals.debug_panel.add_property("energy", "%3.2f" % (get_real_velocity().length_squared() / 2 + position.y * ProjectSettings.get_setting("physics/3d/default_gravity")));
	Globals.debug_panel.add_property("rotation", "%3.1f, %3.1f" % [rad_to_deg($Camera_Controller.rot.x), rad_to_deg($Camera_Controller.rot.y)]);
	Globals.debug_panel.add_property("movement_state", $Movement_Controller.get_current_move_state());


func swap_controller(new_controller : Controller_Base) -> Node:
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
	return old_controller;


func equip_weapon(weapon : Weapon):
	if self.weapon: self.weapon.queue_free();
	$Camera_Controller.get_head().add_child(weapon);
	self.weapon = weapon;
