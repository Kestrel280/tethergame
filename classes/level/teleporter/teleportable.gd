class_name Teleportable
extends Node

# Attach to a collision shape. If the collision shape enters a teleporter,
# 	the teleporter will check the collision shape owner's children for the
# 	existence of a Teleportable node.

@export var body : Node3D; # Body to be teleported (position, velocity, & x-rotation)
@export var head : Node3D; # If teleporter has set_view_angle, 
