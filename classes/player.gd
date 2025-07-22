class_name Player
extends CharacterBody3D

@export var camera_controller_script : GDScript;
@export var input_controller_script : GDScript;
@export var movement_controller_script : GDScript;
var camera_controller : Camera_Controller;
var input_controller : Input_Controller;
var movement_controller : Movement_Controller;


var _rot : Vector2 = Vector2.ZERO;


func _input(event) -> void:
	input_controller.handle_input(event);


func _ready() -> void:
	camera_controller = camera_controller_script.new();
	input_controller = input_controller_script.new();
	movement_controller = movement_controller_script.new();
	camera_controller.start(self, $Head, $Head/Camera3D);
	pass


func _physics_process(delta: float) -> void:
	# Get player's inputs
	var input_dir_flat = input_controller.input_dir_flat();
	var holding_jump = input_controller.jumping();
	_rot -= input_controller.incremental_rotation() * input_controller.sensitivity / ProjectSettings.get_setting("display/window/size/viewport_width");
	_rot.x = wrapf(_rot.x, -PI, PI);
	_rot.y = clampf(_rot.y, -PI/2, PI/2);

	camera_controller.set_rotation(_rot.x, _rot.y);
	
