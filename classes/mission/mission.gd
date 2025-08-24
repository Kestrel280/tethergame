class_name Mission
extends Node


@export var start_trigger : Node3D;
@export var end_trigger : Node3D;
@export var must_pass_triggers : Array[Node3D];
@export var fail_triggers : Array[Node3D];


var running : bool = false;
var start_time_ticks : int;
var run_time_ticks : int;



func _on_start_trigger_triggered(body: Node3D) -> void:
	print("mission %s has recognized that the start trigger has been triggered" % name);
	running = true;
	start_time_ticks = Time.get_ticks_msec();


func _on_end_trigger_triggered(body: Node3D) -> void:
	print("mission has recognized that the end trigger has been triggered");
	running = false;
	run_time_ticks = Time.get_ticks_msec() - start_time_ticks;
	print(run_time_ticks);


func _ready() -> void:
#	start_trigger.triggered.connect(on_start_trigger_triggered);
#	end_trigger.triggered.connect(on_end_trigger_triggered);
	pass


func _process(delta: float) -> void:
	pass
