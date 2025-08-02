class_name Weapon_Shoot_Action
extends Node


const cast_length : float = 100.0;


@warning_ignore_start("unused_parameter")
func shoot(weapon_carrier : Player, weapon : Weapon) -> void:
	var space_state = weapon_carrier.get_world_3d().direct_space_state;
	var query = PhysicsRayQueryParameters3D.create(weapon.global_position, weapon.global_position - cast_length * weapon.global_transform.basis.z);
	query.exclude = [weapon_carrier];
	var result = space_state.intersect_ray(query);
	if result: print("default shoot action hit %s at %s" % [result.collider, result.position]);
	else: print("default shoot action missed");


func stop_shoot(weapon_carrier : Player, weapon : Weapon) -> void:
	print("default shoot action stop_shoot()");


func abort_shoot(weapon_carrier : Player, weapon : Weapon) -> void:
	print("default shoot action abort_shoot");
@warning_ignore_restore("unused_parameter")
