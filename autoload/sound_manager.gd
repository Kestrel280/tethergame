extends Node


# TODO make this better, maybe pooled stream players or something


func play_sound(stream : AudioStream):
	var stream_player : AudioStreamPlayer = AudioStreamPlayer.new();
	add_child(stream_player);
	stream_player.stream = stream;
	stream_player.play();
	stream_player.finished.connect(func(): stream_player.queue_free());
