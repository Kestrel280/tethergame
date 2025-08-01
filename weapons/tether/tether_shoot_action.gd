extends Weapon_Shoot_Action


var stored_movement_controller : Movement_Controller_Base;
var movement_controller_tethered : Movement_Controller_State_Machine = Movement_Controller_State_Machine.construct([Tethered_Idle_State.new(), Tethered_Walk_State.new(), Tethered_Air_State.new()]);
var rope_scene : PackedScene = preload("res://weapons/tether/rope.tscn");
var rope : MeshInstance3D;
var draw_debug_sphere : bool = true;
var debug_sphere : MeshInstance3D;
var anchor_position : Vector3;
var anchor_sqdist : float;
var anchored : bool;


## Tether:
## On shoot:
##	Raycast to find anchor point & anchored_object
## 	Create a tethered movement controller
## 	Start the tethered movement controller, passing anchor location as aux info
##	Swap out weapon_carrier's movement controller for tethered movement controller
## On stop_shoot:
## 	Swap back in the original movement controller
func shoot():
	var space_state = weapon_carrier.get_world_3d().direct_space_state;
	var query = PhysicsRayQueryParameters3D.create(weapon.global_position, weapon.global_position - cast_length * weapon.global_transform.basis.z);
	query.exclude = [weapon_carrier];
	var result = space_state.intersect_ray(query);
	if result:
		anchored = true;
		anchor_position = result.position;
		anchor_sqdist = weapon_carrier.global_position.distance_squared_to(result.position);
		var anchor_data : Dictionary = {
			"anchor_position": anchor_position,
			"anchor_sqdist": anchor_sqdist
		};
		# Then start the movement controller
		movement_controller_tethered.start(weapon_carrier, anchor_data);
		# Then give the movement controller to the carrier
		stored_movement_controller = weapon_carrier.swap_controller(movement_controller_tethered);
		# Play a sound
		Sound_Manager.play_sound(weapon.weapon_res.hit_sound);
		# Create the rope mesh and add it as a child of the weapon
		rope = rope_scene.instantiate();
		rope.top_level = true;
		weapon.add_child(rope);
		update_rope();

		# Create the debug sphere and add it as a child of the hit entity
		if draw_debug_sphere:
			debug_sphere = MeshInstance3D.new();
			debug_sphere.mesh = SphereMesh.new();
			debug_sphere.mesh.material = preload("res://assets/materials/debug/debug_transparent_grid_material.tres");
			debug_sphere.top_level = true;
			debug_sphere.mesh.radius = sqrt(anchor_sqdist);
			debug_sphere.mesh.height = sqrt(anchor_sqdist) * 2;
			result.collider.add_child(debug_sphere);
			debug_sphere.global_position = result.position;


func stop_shoot():
	if anchored:
		anchored = false;
		Sound_Manager.play_sound(weapon.weapon_res.unshoot_sound);
		rope.queue_free();
		if debug_sphere: debug_sphere.queue_free();
		
	if stored_movement_controller:
		weapon_carrier.swap_controller(stored_movement_controller);
		stored_movement_controller = null;


func abort_shoot():
	stop_shoot();


@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if anchored:
		update_rope();
		if debug_sphere:
			debug_sphere.mesh.radius = sqrt(anchor_sqdist);
			debug_sphere.mesh.height = sqrt(anchor_sqdist) * 2;


func update_rope():
	rope.mesh.height = (weapon.mesh.global_position - anchor_position).length();
	rope.global_position = lerp(anchor_position, weapon.mesh.global_position, 0.5);
	rope.look_at(weapon.mesh.global_position);
	rope.rotate_object_local(Vector3.RIGHT, PI / 2);
