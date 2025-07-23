class_name Controller_Base
extends Node

# Abstract base class for Controllers, used for comparing types of Controllers
# Controllers must override get_controller_base_class()

func get_controller_name() -> StringName:
	assert(false, "Controller does not implement get_controller_name()!");
	return "";


func _ready():
	self.name = get_controller_name();
	print("New '%s' created" % self.name);
