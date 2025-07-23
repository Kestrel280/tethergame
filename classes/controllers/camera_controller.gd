class_name Camera_Controller
extends Resource


# Users of the component must set these!
var body : Node3D;
var head : Node3D;
var camera : Camera3D;

# Don't override these
func start(body : Node3D, head : Node3D, camera : Camera3D):
	self.body = body;
	self.head = head;
	self.camera = camera;


func set_rotation(right : float, up : float):
	body.rotation.y = right;
	head.rotation.x = up;
