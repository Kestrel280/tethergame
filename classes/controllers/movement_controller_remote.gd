class_name Movement_Controller_Remote
extends Movement_Controller_Base


func inject(pos : Vector3, vel : Vector3):
	body.position = pos;
	body.velocity = vel;
