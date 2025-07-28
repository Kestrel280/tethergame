class_name Weapon
extends Node3D


var carrier : Node3D;
var mesh : MeshInstance3D;
var shoot_action : Weapon_Shoot_Action;
var in_shot_cooldown : bool = false;
var weapon_res : Weapon_Resource;


func _init(_carrier : Node3D, _weapon_res : Weapon_Resource):
	self.carrier = _carrier;
	self.weapon_res = _weapon_res;
	mesh = MeshInstance3D.new();
	mesh.mesh = weapon_res.mesh;
	mesh.position = weapon_res.position;
	mesh.rotation_degrees = weapon_res.orientation;
	shoot_action = weapon_res.shoot_script.new();


func _ready() -> void:
	add_child(mesh);


func try_shoot() -> bool:
	if in_shot_cooldown: return false;
	
	in_shot_cooldown = true;
	shoot_action.shoot(carrier, self);
	get_tree().create_timer(weapon_res.shot_cooldown).timeout.connect(func(): in_shot_cooldown = false);
	return true;


func stop_shoot() -> void:
	shoot_action.stop_shoot(carrier, self);


func abort_shoot() -> void:
	shoot_action.abort_shoot(carrier, self);
