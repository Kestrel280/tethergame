class_name Client
extends Node


signal connected;
signal disconnected();


enum Message_Type {
	CHANGELEVEL,
}


const MAX_RETRY : int = 15;
const RETRY_TIMEOUT : float = 1.0;
var is_connected : bool = false;
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
	is_connected = true;
	connected.emit();
	return true;


func stop() -> void:
	if socket == null: return;
	is_connected = false;
	socket.close();
	while socket.get_ready_state() != socket.STATE_CLOSED:
		await get_tree().create_timer(1.0).timeout;
		socket.poll();
	socket = null;
	disconnected.emit();


func send(mtype : Server.Message_Type, payload : PackedByteArray = PackedByteArray()) -> bool:
	if !is_connected: return false;
	var msg : PackedByteArray = PackedByteArray();
	msg.append(mtype);
	msg.append_array(payload);
	socket.send(msg);
	return true;


func _process(dt : float) -> void:
	if socket != null: socket.poll()
	
	if !is_connected: return;
	
	# Process packets
	if socket.get_ready_state() == WebSocketPeer.STATE_OPEN:
		while socket.get_available_packet_count():
			var msg : PackedByteArray = socket.get_packet();
			var mtype : int = msg[0];
			var payload : PackedByteArray = msg.slice(1);
			match mtype:
				Message_Type.CHANGELEVEL: Message_Bus.change_level_requested.emit(payload.get_string_from_ascii(), self);
	else:
		print("Lost connection to server");
		stop();
