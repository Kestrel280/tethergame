class_name Weapon
extends Node3D


var weapon_carrier : Node3D;
var mesh : MeshInstance3D;
var shoot_action : Weapon_Shoot_Action;
var in_shot_cooldown : bool = false;
var weapon_res : Weapon_Resource;


func _init(_weapon_carrier : Node3D, _weapon_res : Weapon_Resource):
	weapon_carrier = _weapon_carrier;
	weapon_res = _weapon_res;
	mesh = MeshInstance3D.new();
	mesh.mesh = weapon_res.mesh;
	mesh.position = weapon_res.position;
	mesh.rotation_degrees = weapon_res.orientation;
	shoot_action = weapon_res.shoot_script.new(weapon_carrier, self);
	add_child(shoot_action);


func _ready() -> void:
	add_child(mesh);


func try_shoot() -> bool:
	if in_shot_cooldown: return false;
	
	in_shot_cooldown = true;
	shoot_action.shoot();
	get_tree().create_timer(weapon_res.shot_cooldown).timeout.connect(func(): in_shot_cooldown = false);
	return true;


func stop_shoot() -> void:
	shoot_action.stop_shoot();


func abort_shoot() -> void:
	shoot_action.abort_shoot();
