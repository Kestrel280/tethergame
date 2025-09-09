class_name Player
extends CharacterBody3D


signal toggled_movemode;
signal changed_weapon(new_weapon : int);


var weapon : Weapon; # Currently equipped weapon
var network_manager : Client = null;


static func construct(_network_manager : Client = null) -> Player:
	var p : Player = preload("Player.tscn").instantiate();
	p.network_manager = _network_manager;
	return p;


func get_player_data(dt : float = 0.0) -> Player_Packet:
	# Snapshot current state of player
	# Can be serialized using var_to_bytes_with_objects(Player_Packet) -> deserialized with bytes_to_var_with_objects()
	var pd : Player_Packet = Player_Packet.new();
	pd.position = self.position;
	pd.velocity = self.velocity;
	pd.rotation = $Camera_Controller.get_rotation();
	pd.look_basis = $Camera_Controller.get_look_basis();
	pd.input_dir = $Input_Controller.get_input_dir();
	pd.jumping = $Input_Controller.get_jumping();
	pd.crouching = $Input_Controller.get_crouching();
	pd.shooting = weapon.shooting if weapon else false;
	pd.interacting = $Input_Controller.get_interacting();
	pd.tick_dt = dt;
	return pd;


func _unhandled_input(event : InputEvent):
	if event is InputEventKey and event.pressed and event.keycode == KEY_L:
		if network_manager: network_manager.send(Server.Message_Type.DEBUG);
	elif event is InputEventKey and event.pressed and event.keycode == KEY_K:
		if network_manager: network_manager.send(Server.Message_Type.UNHANDLED);


func _ready() -> void:
	var head : Node3D = find_child("Head");
	var camera : Camera3D = head.find_child("Camera3D") if head else null;
	install_input_controller($Input_Controller);
	$Camera_Controller.start(self, head, camera);
	$Movement_Controller.start(self);


@warning_ignore("unused_parameter")
func _process(delta : float) -> void:
	$Camera_Controller.add_rotation(-$Input_Controller.get_incremental_rotation());


func _physics_process(dt: float) -> void:
	if network_manager: tick(dt);
	
	Globals.debug_panel.add_property("position", "%3.2f, %3.2f, %3.2f" % [position.x, position.y, position.z]);
	Globals.debug_panel.add_property("velocity", "%3.2f, %3.2f, %3.2f" % [get_real_velocity().x, get_real_velocity().y, get_real_velocity().z]);
	Globals.debug_panel.add_property("xy_speed", "%3.2f" % Vector2(get_real_velocity().x, get_real_velocity().z).length());
	Globals.debug_panel.add_property("energy", "%3.2f" % (get_real_velocity().length_squared() / 2 + position.y * ProjectSettings.get_setting("physics/3d/default_gravity")));
	Globals.debug_panel.add_property("rotation", "%3.1f, %3.1f" % [$Camera_Controller.get_rotation().x, $Camera_Controller.get_rotation().y]);
	Globals.debug_panel.add_property("look_dir", str(-$Camera_Controller.get_look_basis().z));
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


func tick(dt : float):
	if network_manager: network_manager.send(Server.Message_Type.PLAYER_PACKET, var_to_bytes_with_objects(get_player_data(dt)));
	$Movement_Controller.jumping = $Input_Controller.get_jumping();
	$Movement_Controller.move(dt, ($Camera_Controller.get_look_basis() * $Input_Controller.get_input_dir()).normalized());


func toggle_viewmode():
	var new_cc : Camera_Controller_Base;
	if $Camera_Controller is Camera_Controller_1st_Person: new_cc = Camera_Controller_3rd_Person.new();
	else: new_cc = Camera_Controller_1st_Person.new();
	new_cc.start(self, $Head, $Head/Camera3D, $Camera_Controller.rot);
	swap_controller(new_cc);
	if network_manager: network_manager.send(Server.Message_Type.PLAYER_TOGGLED_VIEW_MODE);


func toggle_movemode():
	var new_mc : Movement_Controller_State_Machine;
	if $Movement_Controller.get_current_move_state().get_slice("_", 0) != "Player": return;
	if $Movement_Controller.get_current_move_state().split("_").has("Flymode"):
		new_mc = Movement_Controller_State_Machine.construct([Player_Idle_State.new(), Player_Walk_State.new(), Player_Air_State.new()]);
	else: new_mc = Movement_Controller_State_Machine.construct([Player_Flymode_Idle_State.new(), Player_Flymode_Walk_State.new(), Player_Flymode_Air_State.new()]);
	new_mc.start(self);
	swap_controller(new_mc);
	if network_manager: network_manager.send(Server.Message_Type.PLAYER_TOGGLED_MOVE_MODE);
	toggled_movemode.emit();


func change_weapon(weapon_num : int):
	var new_weapon : Weapon;
	print("changed weapon to %d" % weapon_num);
	match weapon_num:
		1: new_weapon = Weapon.new(self, preload("res://weapons/pistol/pistol.tres"));
		2: new_weapon = Weapon.new(self, preload("res://weapons/tether/tether.tres"));
	if weapon:
		weapon.abort_shoot();
		weapon.queue_free();
	$Camera_Controller.get_head().add_child(new_weapon);
	weapon = new_weapon;
	if network_manager: network_manager.send(Server.Message_Type.PLAYER_CHANGED_WEAPON, PackedByteArray([weapon_num]));
	changed_weapon.emit(weapon_num);


func install_input_controller(ic : Input_Controller_Base):
	ic.pressed_toggle_viewmode.connect(toggle_viewmode);
	ic.pressed_toggle_movemode.connect(toggle_movemode);
	ic.pressed_change_weapon.connect(change_weapon);
	
	ic.pressed_shoot.connect(func(): if weapon: weapon.try_shoot());
	ic.released_shoot.connect(func(): if weapon: weapon.stop_shoot());
