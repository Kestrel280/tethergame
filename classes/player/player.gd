class_name Player
extends CharacterBody3D


var _rot : Vector2 = Vector2.ZERO; # Cumulative rotation of the player
var weapon : Weapon; # Currently equipped weapon


# TODO find a better place for these; referenced in movement states
@export_range(2.0, 10.0) var max_ground_speed = 5.0;
@export_range(0.1, 1.0) var ground_accel = 0.3;
@export_range(0.1, 1.0) var ground_friction = 0.3;
@export_range(2.0, 10.0) var jump_impulse = 4.0;
@export_range(1.0, 3.0) var air_speed_cap = 0.5; # Per-frame max speed to add
@export_range(10, 500.0) var air_accel = 150.0; # How aggressively to apply air_speed_cap


static func construct() -> Player:
	return preload("Player.tscn").instantiate();


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



func _ready() -> void:
	$Camera_Controller.start(self, $Head, $Head/Camera3D);
	$Movement_Controller.start(self);


func _physics_process(delta: float) -> void:
	# Get player's inputs
	var input_dir_raw = $Input_Controller.input_dir_raw();
	$Camera_Controller.add_rotation(-$Input_Controller.incremental_rotation() / ProjectSettings.get_setting("display/window/size/viewport_width"));
	
	var input_dir = ($Head.transform.basis * input_dir_raw).normalized();
	$Movement_Controller.jumping = $Input_Controller.is_trying_jump();
	$Movement_Controller.move(delta, (self.transform.basis * input_dir).normalized());
	
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
	if self.weapon:
		self.weapon.queue_free();
	$Camera_Controller.get_head().add_child(weapon);
	self.weapon = weapon;
