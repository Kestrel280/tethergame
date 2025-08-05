class_name Weapon
extends Node3D


var weapon_carrier : Node3D;
var mesh : MeshInstance3D;
var weapon_logic : Weapon_Logic;
var ui_scene : Control;
var in_shot_cooldown : bool = false;
var weapon_res : Weapon_Resource;


func _init(_weapon_carrier : Node3D, _weapon_res : Weapon_Resource):
	weapon_carrier = _weapon_carrier;
	weapon_res = _weapon_res;
	if weapon_res.ui_scene: ui_scene = weapon_res.ui_scene.instantiate();
	mesh = MeshInstance3D.new();
	mesh.mesh = weapon_res.mesh;
	mesh.position = weapon_res.position;
	mesh.rotation_degrees = weapon_res.orientation;
	weapon_logic = weapon_res.weapon_logic.new(weapon_carrier, self, ui_scene);
	add_child(weapon_logic);
	add_child(ui_scene);


func _ready() -> void:
	add_child(mesh);


func try_shoot() -> bool:
	if in_shot_cooldown: return false;
	
	in_shot_cooldown = true;
	weapon_logic.shoot();
	get_tree().create_timer(weapon_res.shot_cooldown).timeout.connect(func(): in_shot_cooldown = false);
	return true;


func stop_shoot() -> void:
	weapon_logic.stop_shoot();


func abort_shoot() -> void:
	weapon_logic.abort_shoot();
