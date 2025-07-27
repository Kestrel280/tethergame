extends Node


# TODO make this better, maybe pooled stream players or something

var x : int = 0;


func play_sound(stream : AudioStream):
	print(x);
	x += 1;
	var stream_player : AudioStreamPlayer = AudioStreamPlayer.new();
	add_child(stream_player);
	stream_player.stream = stream;
	stream_player.play();
	stream_player.finished.connect(func(): stream_player.queue_free());
