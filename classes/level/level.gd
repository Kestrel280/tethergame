class_name Level
extends Node


# Don't override these
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED);


@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("debug_spawn_nonuser_player"):
		var p : Player = Player.construct();
		var movctl : Movement_Controller_Base = Movement_Controller_Remote.new();
		var camctl : Camera_Controller_Base = Camera_Controller_Remote.new();
		var inpctl : Input_Controller_Base = Input_Controller_Remote.new();
		movctl.start(p);
		camctl.start(p, p.get_node("Head"), p.get_node("Head/Camera3D"));
		add_child(p);
		p.swap_controller(movctl, true);
		p.swap_controller(camctl, true);
		p.swap_controller(inpctl, true);
		p.remove_child(p.get_node("Player_Ui"));


# Override these
func spawn_player(player : Player) -> void:
	add_child(player);


func do_intro() -> void:
	pass;
