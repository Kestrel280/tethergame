class_name Controller_Base
extends Node

## Abstract base class for Controllers, used for comparing types of Controllers.
## Controllers must override get_controller_base_class().
##	(this is typically provided by Base controller classes, 
## 	so bottom-level controllers generally don't need to do this.)
## They MAY define a construct() function, which instantiates a new
## copy of the controller for convenience; but this is optional.

func get_controller_name() -> StringName:
	assert(false, "Controller does not implement get_controller_name()!");
	return "";


func _ready():
	self.name = get_controller_name();
	print("New '%s' created" % self.name);


static func construct() -> Variant:
	return null;
