class_name Anchor_Info
extends Node3D


var counterweight : Node3D; # The object which created the anchor; e.g. the weapon that the player shot
var embedded_object : Node3D; # The object the anchor is embedded in
var anchor_point : Vector3; # Where the anchor is in global space
var sqdist : float; # At initialization, square distance from the counterweight to anchor_point
var debug_sphere : MeshInstance3D = null;
var rope : MeshInstance3D = null;


func _init(_counterweight : Node3D, _embedded_object : Node3D, _anchor_point : Vector3, _sqdist : float, _rope : MeshInstance3D = null, draw_debug_sphere : bool = false):
	counterweight = _counterweight;
	anchor_point = _anchor_point;
	embedded_object = _embedded_object;
	sqdist = _sqdist;
	
	if _rope:
		rope = _rope;
		rope.top_level = true;
		counterweight.add_child(rope);
	if draw_debug_sphere:
		debug_sphere = MeshInstance3D.new();
		debug_sphere.top_level = true;
		debug_sphere.mesh = SphereMesh.new();
		debug_sphere.mesh.radius = sqrt(sqdist);
		debug_sphere.mesh.height = sqrt(sqdist) * 2;
		debug_sphere.mesh.material = preload("res://assets/materials/debug/debug_transparent_grid_material.tres");
		embedded_object.add_child(debug_sphere);
		debug_sphere.global_position = anchor_point;


@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	if rope:
		rope.mesh.height = (counterweight.global_position - anchor_point).length();
		rope.global_position = lerp(anchor_point, counterweight.global_position, 0.5);
		rope.look_at(anchor_point);
		rope.rotate_object_local(Vector3.RIGHT, PI / 2);
	if debug_sphere:
		debug_sphere.mesh.radius = sqrt(sqdist);
		debug_sphere.mesh.height = sqrt(sqdist) * 2;


# Clean up after ourselves: when we're freed, delete the debug sphere
func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		if debug_sphere:
			embedded_object.remove_child(debug_sphere);
			debug_sphere.queue_free();
		if rope:
			counterweight.remove_child(rope);
			rope.queue_free();
