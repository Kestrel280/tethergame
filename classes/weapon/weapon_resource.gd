class_name Weapon_Resource
extends Resource

@export_subgroup("Visuals")
@export var mesh : Mesh;
@export var position : Vector3;
@export var orientation : Vector3;
@export_subgroup("Properties")
@export var single_shot : bool = false;
@export var shoot_script : GDScript;
