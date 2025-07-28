class_name Debug_Panel
extends Control


func _ready():
	Globals.debug_panel = self;


func add_property(key : String, val : String):
	var label : Label;
	if $Labels.has_node(key): label = $Labels.get_node(key);
	else: 
		label = Label.new();
		label.name = key;
		$Labels.add_child(label);
	label.text = "%s: %s" % [key, val];


func delete_property(key : String):
	var label : Label = $Labels.get_node(key);
	if label:
		label.queue_free();
		remove_child(label);


func remove_all_properties():
	for child in $Labels.get_children():
		child.queue_free();
