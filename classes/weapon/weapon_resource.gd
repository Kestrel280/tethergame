class_name Weapon_Resource
extends Resource

@export_subgroup("Visuals")
@export var mesh : Mesh;
@export var position : Vector3;
@export var orientation : Vector3;
@export var ui_scene : PackedScene;
@export_subgroup("Sounds")
@export var shoot_sound : AudioStream;
@export var hit_sound : AudioStream;
@export var miss_sound : AudioStream;
@export var unshoot_sound : AudioStream;
@export_subgroup("Properties")
@export var single_shot : bool = false;
@export_range(0.05, 5.0) var shot_cooldown : float = 0.2;
@export var shoot_script : GDScript;
