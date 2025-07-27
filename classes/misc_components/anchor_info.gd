class_name Anchor_Info
extends Node3D


var counterweight : Node3D; # The object which created the anchor; e.g. the weapon that the player shot
var embedded_object : Node3D; # The object the anchor is embedded in
var anchor_point : Vector3; # Where the anchor is in global space
var rope_material : BaseMaterial3D;
var sqdist : float; # At initialization, square distance from the counterweight to anchor_point
var debug_sphere : MeshInstance3D = null;
var rope : MeshInstance3D = null;


func _init(counterweight : Node3D, embedded_object : Node3D, anchor_point : Vector3, rope_material : BaseMaterial3D = null, draw_debug_sphere : bool = false):
	self.counterweight = counterweight;
	self.anchor_point = anchor_point;
	self.embedded_object = embedded_object;
	self.rope_material = rope_material;
	self.sqdist = counterweight.global_position.distance_squared_to(anchor_point);
	
	if rope_material:
		rope = MeshInstance3D.new();
		rope.top_level = true;
		self.counterweight.add_child(rope);
	if draw_debug_sphere:
		debug_sphere = MeshInstance3D.new();
		debug_sphere.top_level = true;
		debug_sphere.global_position = anchor_point;
		debug_sphere.mesh = SphereMesh.new();
		debug_sphere.mesh.radius = sqrt(self.sqdist);
		debug_sphere.mesh.height = sqrt(self.sqdist) * 2;
		debug_sphere.mesh.material = preload("res://assets/materials/debug/debug_transparent_grid_material.tres");
		self.embedded_object.add_child(debug_sphere);


func _physics_process(delta: float) -> void:
	if rope:
		var rope_mesh = CylinderMesh.new();
		rope_mesh.bottom_radius = 0.02;
		rope_mesh.top_radius = 0.02;
		rope_mesh.height = (counterweight.global_position - anchor_point).length();
		rope.global_position = lerp(anchor_point, counterweight.global_position, 0.5);
		rope.look_at(anchor_point);
		rope.rotate_object_local(Vector3.RIGHT, PI / 2);
		rope.mesh = rope_mesh;
		rope.mesh.material = rope_material;
	if debug_sphere: 
		debug_sphere.mesh.radius = sqrt(self.sqdist);
		debug_sphere.mesh.height = sqrt(self.sqdist) * 2;


# Clean up after ourselves: when we're freed, delete the debug sphere
func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		if debug_sphere:
			embedded_object.remove_child(debug_sphere);
			debug_sphere.queue_free();
		if rope:
			counterweight.remove_child(rope);
			rope.queue_free();
