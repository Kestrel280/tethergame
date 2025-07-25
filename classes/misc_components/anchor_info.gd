class_name Anchor_Info
extends Node3D


var counterweight : Node3D; # The object which created the anchor; e.g. the player swinging from the grapple
var embedded_object : Node3D; # The object the anchor is embedded in
var anchor_point : Vector3; # Where the anchor is in global space
var sqdist : float; # At initialization, square distance from the counterweight to anchor_point
var debug_sphere : MeshInstance3D = null;


func _init(counterweight : Node3D, embedded_object : Node3D, anchor_point : Vector3, draw_debug_sphere : bool = false):
	self.anchor_point = anchor_point;
	self.embedded_object = embedded_object;
	self.sqdist = counterweight.global_position.distance_squared_to(anchor_point);
	
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
	if debug_sphere: 
		debug_sphere.mesh.radius = sqrt(self.sqdist);
		debug_sphere.mesh.height = sqrt(self.sqdist) * 2;


# Clean up after ourselves: when we're freed, delete the debug sphere
func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		if debug_sphere:
			embedded_object.remove_child(debug_sphere);
			debug_sphere.queue_free();
