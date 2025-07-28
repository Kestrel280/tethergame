extends Weapon_Shoot_Action


var anchor_info : Anchor_Info;
var stored_movement_controller : Movement_Controller_Base;
var movement_controller_tethered : Movement_Controller_State_Machine = Movement_Controller_State_Machine.construct([Tethered_Idle_State.new(), Tethered_Walk_State.new(), Tethered_Air_State.new()]);
var rope = preload("res://weapons/tether/rope.tscn");


## Tether:
## On shoot:
##	Raycast to find anchor point & anchored_object
## 	Install an Anchor_Info node on the weapon_carrier
## 	Create a tethered movement controller, whose states will look for the Anchor_Info node above
## 	(order of operation matters!)
##	Swap out weapon_carrier's movement controller for tethered movement controller
## On stop_shoot:
##	Destroy the "Tether_Anchor"
## 	Swap back in the original movement controller
func shoot(weapon_carrier : Player, weapon : Weapon):
	var space_state = weapon_carrier.get_world_3d().direct_space_state;
	var query = PhysicsRayQueryParameters3D.create(weapon.global_position, weapon.global_position - cast_length * weapon.global_transform.basis.z);
	query.exclude = [weapon_carrier];
	var result = space_state.intersect_ray(query);
	if result:
		# First, create the anchor
		var sqdist : float = weapon_carrier.global_position.distance_squared_to(result.position);
		anchor_info = Anchor_Info.new(weapon.mesh, result.collider, result.position, sqdist, rope.instantiate(), true);
		anchor_info.name = "Tether_Anchor_Info";
		# Then add it to the carrier
		weapon_carrier.add_child(anchor_info);
		# Then start the movement controller
		movement_controller_tethered.start(weapon_carrier);
		# Then give the movement controller to the carrier
		stored_movement_controller = weapon_carrier.swap_controller(movement_controller_tethered);
		# Play a sound
		Sound_Manager.play_sound(weapon.weapon_res.hit_sound);
	else:
		Sound_Manager.play_sound(weapon.weapon_res.miss_sound);


func stop_shoot(weapon_carrier : Player, weapon : Weapon):
	if anchor_info:
		Sound_Manager.play_sound(weapon.weapon_res.unshoot_sound);
		anchor_info.queue_free();
	if stored_movement_controller:
		weapon_carrier.swap_controller(stored_movement_controller);
		stored_movement_controller = null;


func abort_shoot(weapon_carrier : Node3D, weapon : Weapon):
	stop_shoot(weapon_carrier, weapon);


@warning_ignore("unused_parameter")
func _physics_update(dt : float):
	print("hello");
	pass;
