class_name Label_Kinetic
extends Label


@export var base_color : Color = Color(1, 1, 1);
@export var gain_color : Color = Color(0, 0.5, 1);
@export var loss_color : Color = Color (1, 0.5, 0);
@export_range(0.0, 1.0) var max_gain : float = 0.5;
@export_range(-1.0, 0.0) var max_loss : float = -0.5;
@export_range(0.1, 1.0) var smoothing_factor : float = 0.5;


var smoothed_value : float = 0;
var current_color : Color = base_color;


func _ready():
	label_settings = preload("kinetic_label_setting.tres").duplicate();
	clip_text = true;


func set_value(new_value : float):
	smoothed_value = lerp(smoothed_value, new_value, smoothing_factor);
	var delta : float = new_value - smoothed_value;
	var new_color = lerp(base_color, loss_color, min(1.0, delta / max_loss)) if delta < 0 else lerp(base_color, gain_color, min(1.0, delta / max_gain));
	text = "%.1f" % new_value;
	label_settings.font_color = new_color;
