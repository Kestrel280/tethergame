@tool
class_name Teleporter
extends Area3D


@export var destination : Node3D:
	set(d):
		destination = d;
		update_configuration_warnings();
@export var preserve_xy_velocity : bool = false;
@export var preserve_z_velocity : bool = false;
@export var add_speed : float = 0.0;
@export var set_view_angle : bool = true;


func _get_configuration_warnings():
	if !destination:
		return ["Teleporter has no destination. Assign in the inspector, or ensure that code will set one before the teleporter is used."]


func _on_body_entered(body: Node3D) -> void:
	# If the body does not have a Teleportable component, do nothing
	if !(body.get_children().any(func(x): return x is Teleportable)): return;
	
	body.global_position = destination.global_position;
	body.velocity.x = body.velocity.x if preserve_xy_velocity else 0;
	body.velocity.y = body.velocity.y if preserve_z_velocity else 0;
	body.velocity.z = body.velocity.z if preserve_xy_velocity else 0;
	if add_speed: body.velocity += (destination.transform.basis.x * add_speed);
	if set_view_angle:
		var cc : Camera_Controller_Base = null;
		for child in body.get_children():
			if child is Camera_Controller_Base:
				cc = child;
				break;
		if cc: cc.look_at(destination.transform.basis.x);
