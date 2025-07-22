class_name Camera_Controller
extends Resource


# Users of the component must set these!
var body : Node3D;
var head : Node3D;
var camera : Camera3D;


func start(body : Node3D, head : Node3D, camera : Camera3D):
	self.body = body;
	self.head = head;
	self.camera = camera;
	print(body, head, camera);


func look_at(dir : Vector3):
	var rot_x = -dir.slide(Vector3(0, 1, 0)).angle_to(Vector3(0, 0, -1)); # project onto xz plane and get angle from -z axis
	var rot_y = -dir.slide(Vector3(0, 0, 1)).angle_to(Vector3(1, 0, 0)); # up/down: project onto xy plane and get angle from x axis
	set_rotation(rot_x, rot_y);

	
func set_rotation(right : float, up : float):
	body.rotation.y = right;
	head.rotation.x = up;
