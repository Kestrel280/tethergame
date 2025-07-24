class_name Weapon_Shoot_Action
extends Resource


const cast_length : float = 100.0;


func shoot(weapon_carrier : Node3D, weapon : Weapon):
	var space_state = weapon_carrier.get_world_3d().direct_space_state;
	var query = PhysicsRayQueryParameters3D.create(weapon.global_position, weapon.global_position - cast_length * weapon.global_transform.basis.z);
	query.exclude = [weapon_carrier];
	var result = space_state.intersect_ray(query);
	if result: print("default_shoot_action hit %s at %s" % [result.collider, result.position]);
	else: print("default_shoot_action missed");
