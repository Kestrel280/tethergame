class_name Movement_Controller_Base
extends Node


## Movement controllers must define a move(dt : float) function,
## which updates the location of the body it is controlling (set via start()).
## There are no other requirements; the movement_state_machine can be null if not needed.


signal movement_state_changed(new_state : StringName);


var jumping : bool;
var movement_state_machine : State_Machine;


# Users of the component must set this!
var body : CharacterBody3D;


# Don't override these
func start(body : Node3D, movement_state_machine : State_Machine):
	self.body = body;
	self.movement_state_machine = movement_state_machine;


func set_jumping(j : bool):
	jumping = j;


# Override these
func move(dt : float, wish_dir : Vector3):
	pass;
