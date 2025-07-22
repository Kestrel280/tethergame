extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_pressed() -> void:
	MessageBus.change_level_requested.emit("testlevel1");


func _on_quit_pressed() -> void:
	MessageBus.player_requested_quit.emit();
