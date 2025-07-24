class_name Camera_Controller_1st_Person
extends Camera_Controller_Base


func start(body : Node3D, head : Node3D, camera : Camera3D, initial_rot : Vector2 = Vector2.ZERO):
	super(body, head, camera, initial_rot);
	camera.position = Vector3.ZERO;
