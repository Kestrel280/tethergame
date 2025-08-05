class_name Weapon
extends Node3D


var carrier : Node3D;
var mesh : MeshInstance3D;
var logic : Weapon_Logic;
var ui_scene : Control;
var in_shot_cooldown : bool = false;
var res : Weapon_Resource;


func _init(_weapon_carrier : Node3D, _weapon_res : Weapon_Resource):
	carrier = _weapon_carrier;
	res = _weapon_res;
	if res.ui_scene: ui_scene = res.ui_scene.instantiate();
	mesh = MeshInstance3D.new();
	mesh.mesh = res.mesh;
	mesh.position = res.position;
	mesh.rotation_degrees = res.orientation;
	logic = res.weapon_logic.new(self);
	add_child(logic);
	add_child(ui_scene);


func _ready() -> void:
	add_child(mesh);


func try_shoot() -> bool:
	if in_shot_cooldown: return false;
	
	in_shot_cooldown = true;
	logic.shoot();
	get_tree().create_timer(res.shot_cooldown).timeout.connect(func(): in_shot_cooldown = false);
	return true;


func stop_shoot() -> void:
	logic.stop_shoot();


func abort_shoot() -> void:
	logic.abort_shoot();
