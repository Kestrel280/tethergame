class_name Camera_Controller_3rd_Person
extends Camera_Controller_Base


# 3rd person controller works by doing a shapecast
# from the head backwards on every frame.
# The shapecast is childed to THE CAMERA CONTROLLER, NOT the head,
# and its position updated every frame,
# to avoid any cleanup issues.


var camera_location = Vector3(0.0, 0.5, 3.5);
var shape_cast : ShapeCast3D;
const shape_cast_radius : float = 0.5;


func _ready():
	super();
	shape_cast = ShapeCast3D.new();
	shape_cast.shape = SphereShape3D.new();
	shape_cast.shape.radius = shape_cast_radius;
	shape_cast.target_position = camera_location;
	add_child(shape_cast);


@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	# Update the transform of the shape cast manually, since it's
	# parented to us and not the head
	shape_cast.global_transform = head.global_transform;
	camera.position = camera_location * shape_cast.get_closest_collision_safe_fraction();
