class_name Camera_Controller_Base
extends Controller_Base


var rot : Vector2 = Vector2.ZERO;


# Users of the component must set these! (using start())
var body : Node3D;
var head : Node3D;
var camera : Camera3D;


# Don't override these, or at least call super()
func get_controller_name():
	return "Camera_Controller";


func start(_body : Node3D, _head : Node3D, _camera : Camera3D, initial_rot = Vector2.ZERO):
	self.body = _body;
	self.head = _head;
	self.camera = _camera;
	self.rot = initial_rot;


func get_head():
	return head;


func add_rotation(r : Vector2):
	rot += r;
	rot.x = wrapf(rot.x, -PI, PI);
	rot.y = clampf(rot.y, -PI/2, PI/2);
	apply_rotation();
	

func apply_rotation():
	body.basis = Basis();
	head.basis = Basis();
	body.rotate_object_local(Vector3(0, 1, 0), rot.x);
	head.rotate_object_local(Vector3(1, 0, 0), rot.y);


func look_at(dir : Vector3):
	rot.x = -atan2(dir.z, dir.x) - PI/2; # Rotation about y axis
	rot.y = PI/2 - acos(dir.y); # Inclination from xz plane
	rot.x = wrapf(rot.x, -PI, PI);
	rot.y = wrapf(rot.y, -PI/2, PI/2);
	apply_rotation();
