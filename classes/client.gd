class_name Client
extends Node


var socket : WebSocketPeer = null;


func start(ip : String = "127.0.0.1"):
	socket = WebSocketPeer.new();
	print("Attempting to initialize Client");
	if socket.connect_to_url("ws://%s:%d" % [ip, Globals.server_port]) != OK:
		print("Invalid server specified in Client init");
	while socket.get_ready_state() != socket.STATE_OPEN:
		await get_tree().create_timer(1.0).timeout;
	print("Client running");
	socket.send_text("Hi, I am now connected");


func stop():
	if socket == null: return;
	socket.close();
	while socket.get_ready_state() != socket.STATE_CLOSED:
		await get_tree().create_timer(1.0).timeout;
		socket.poll();
	socket = null;


func _process(dt : float) -> void:
	if socket == null: return;
	
	# Poll socket to stay up to date
	socket.poll()
	
	# Process packets
	if socket.get_ready_state() == WebSocketPeer.STATE_OPEN:
		while socket.get_available_packet_count():
			print(socket.get_packet().get_string_from_ascii())
