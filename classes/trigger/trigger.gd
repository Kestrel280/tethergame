class_name Trigger
extends Node3D


signal triggered;


# Dummy arguments to accomodate signals which pass arguments
# There may be a way to unbind these arguments ahead of time
#	(built-in "Unbind Signal Arguments" in inspector didn't seem to work?)
func trigger(_a1 = null, _a2 = null, _a3 = null) -> void:
	triggered.emit();
