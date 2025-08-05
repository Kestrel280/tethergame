class_name Weapon_Logic
extends Node


const cast_length : float = 100.0;
var weapon_carrier : Node3D;
var weapon : Weapon;
var weapon_ui : Control;


func _init(_weapon_carrier : Node3D, _weapon : Weapon, _weapon_ui : Control = null):
	weapon_carrier = _weapon_carrier;
	weapon = _weapon;
	weapon_ui = _weapon_ui;


@warning_ignore_start("unused_parameter")
func shoot() -> void:
	var space_state = weapon_carrier.get_world_3d().direct_space_state;
	var query = PhysicsRayQueryParameters3D.create(weapon.global_position, weapon.global_position - cast_length * weapon.global_transform.basis.z);
	query.exclude = [weapon_carrier];
	var result = space_state.intersect_ray(query);
	if result: print("default weapon_logic hit %s at %s" % [result.collider, result.position]);
	else: print("default weapon_logic missed");


func stop_shoot() -> void:
	print("default weapon_logic stop_shoot()");


func abort_shoot() -> void:
	print("default weapon_logic abort_shoot");
@warning_ignore_restore("unused_parameter")
