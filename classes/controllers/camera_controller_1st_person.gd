class_name Camera_Controller_1st_Person
extends Camera_Controller_Base


func start(_body : Node3D, _head : Node3D, _camera : Camera3D, initial_rot : Vector2 = Vector2.ZERO):
	super(_body, _head, _camera, initial_rot);
	camera.position = Vector3.ZERO;
