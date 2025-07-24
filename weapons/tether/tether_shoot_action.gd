extends Weapon_Shoot_Action


var anchor_pos : Vector3;
var stored_movement_controller : Movement_Controller_Base;
var tethered_movement_controller : Movement_Controller_Tethered = Movement_Controller_Tethered.construct();



func shoot(weapon_carrier : Player, weapon : Weapon):
	var space_state = weapon_carrier.get_world_3d().direct_space_state;
	var query = PhysicsRayQueryParameters3D.create(weapon.global_position, weapon.global_position - cast_length * weapon.global_transform.basis.z);
	query.exclude = [weapon_carrier];
	var result = space_state.intersect_ray(query);
	if result:
		tethered_movement_controller.start(weapon_carrier);
		stored_movement_controller = weapon_carrier.swap_controller(tethered_movement_controller);
		print("tethered to %s at %s" % [result.collider, result.position]);
	else: print("tether missed");



func stop_shoot(weapon_carrier : Player):
	if stored_movement_controller:
		weapon_carrier.swap_controller(stored_movement_controller);
		stored_movement_controller = null;


func abort_shoot(weapon_carrier : Node3D):
	stop_shoot(weapon_carrier);
