class_name Client
extends Node

const MAX_RETRY : int = 15;
const RETRY_TIMEOUT : float = 1.0;
var connected : bool = false;
var socket : WebSocketPeer = null;


func start(ip : String = "127.0.0.1") -> bool:
	var retry : int = 0;
	
	# Create socket
	socket = WebSocketPeer.new();
	print("Attempting to initialize Client");
	
	# Connect. _process() loop will handle polling socket for connection status
	if socket.connect_to_url("ws://%s:%d" % [ip, Globals.server_port]) != OK: assert(false, "Invalid server specified in Client init");
	while (socket.get_ready_state() != socket.STATE_OPEN) and (retry < MAX_RETRY):
		await get_tree().create_timer(RETRY_TIMEOUT).timeout;
		retry += 1;
	
	# If failed to connect, abort
	if (socket.get_ready_state() != socket.STATE_OPEN):
		print("Failed to connect to server");
		stop();
		return false;
	
	# Register
	print("Client running");
	connected = true;
	return true;


func stop() -> void:
	if socket == null: return;
	connected = false;
	socket.close();
	while socket.get_ready_state() != socket.STATE_CLOSED:
		await get_tree().create_timer(1.0).timeout;
		socket.poll();
	socket = null;
	

func _process(dt : float) -> void:
	if socket != null: socket.poll()
	
	if !connected: return;
	
	# Process packets
	if socket.get_ready_state() == WebSocketPeer.STATE_OPEN:
		while socket.get_available_packet_count():
			print(socket.get_packet().get_string_from_ascii())
	else:
		print("Lost connection to server");
		stop();
