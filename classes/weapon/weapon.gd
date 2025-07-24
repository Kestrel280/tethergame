class_name Weapon
extends Node3D


var mesh : MeshInstance3D;
var shoot_action : Weapon_Shoot_Action;


func _init(weapon_res : Weapon_Resource):
	mesh = MeshInstance3D.new();
	mesh.mesh = weapon_res.mesh;
	mesh.position = weapon_res.position;
	mesh.rotation_degrees = weapon_res.orientation;
	shoot_action = weapon_res.shoot_script.new();


func _ready() -> void:
	add_child(mesh);
