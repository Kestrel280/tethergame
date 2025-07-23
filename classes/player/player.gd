class_name Player
extends CharacterBody3D

@export var camera_controller_script : GDScript;
@export var input_controller_script : GDScript;
@export var movement_controller_script : GDScript;
var camera_controller : Camera_Controller;
var input_controller : Input_Controller;
var movement_controller : Movement_Controller;


var _rot : Vector2 = Vector2.ZERO; # Cumulative rotation of the player

# TODO find a better place for these; referenced in movement states
@export_range(2.0, 10.0) var max_ground_speed = 5.0;
@export_range(0.1, 1.0) var ground_accel = 0.3;
@export_range(0.1, 1.0) var ground_friction = 0.3;
@export_range(2.0, 10.0) var jump_impulse = 4.0;
@export_range(1.0, 3.0) var air_speed_cap = 0.5; # Per-frame max speed to add
@export_range(10, 500.0) var air_accel = 150.0; # How aggressively to apply air_speed_cap


func _input(event) -> void:
	input_controller.handle_input(event);


func _ready() -> void:
	camera_controller = camera_controller_script.new();
	input_controller = input_controller_script.new();
	movement_controller = movement_controller_script.new();
	camera_controller.start(self, $Head, $Head/Camera3D);
	movement_controller.start(self, $Movement_State_Machine);


func _physics_process(delta: float) -> void:
	# Get player's inputs
	var input_dir_raw = input_controller.input_dir_raw();
	camera_controller.add_rotation(-input_controller.incremental_rotation() * input_controller.sensitivity / ProjectSettings.get_setting("display/window/size/viewport_width"));
	
	var input_dir = ($Head.transform.basis * input_dir_raw).normalized();
	movement_controller.jumping = input_controller.is_trying_jump();
	movement_controller.move(delta, (self.transform.basis * input_dir).normalized());
	
	Globals.debug_panel.add_property("position", "%3.2f, %3.2f, %3.2f" % [position.x, position.y, position.z]);
	Globals.debug_panel.add_property("velocity", "%3.2f, %3.2f, %3.2f" % [get_real_velocity().x, get_real_velocity().y, get_real_velocity().z]);
	Globals.debug_panel.add_property("xy_speed", "%3.2f" % Vector2(get_real_velocity().x, get_real_velocity().z).length());
	Globals.debug_panel.add_property("energy", "%3.2f" % (get_real_velocity().length_squared() / 2 + position.y * ProjectSettings.get_setting("physics/3d/default_gravity")));
	Globals.debug_panel.add_property("rotation", "%3.1f, %3.1f" % [rad_to_deg(camera_controller.rot.x), rad_to_deg(camera_controller.rot.y)]);
	Globals.debug_panel.add_property("movement_state", movement_controller.movement_state_machine.current_state.state_name);
	
