class_name Debug_Panel
extends Control


func _ready():
	Globals.debug_panel = self;


func add_property(key : String, val : String):
	var label : Label = $Labels.get_node(key);
	if !label: 
		label = Label.new();
		label.name = key;
		$Labels.add_child(label);
	label.text = "%s: %s" % [key, val];
