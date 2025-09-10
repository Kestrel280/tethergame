class_name Client
extends Node


signal established_connection;
signal lost_connection;


enum Message_Type {
	CHANGELEVEL,
	PEER_CONNECTED,
	PEER_DISCONNECTED,
	PEER_UPDATE,
}


const MAX_RETRY : int = 5;
const RETRY_TIMEOUT : float = 1.0;
var has_connection : bool = false; # "is_connected" is a reserved attribute in GDScript
var socket : WebSocketPeer = null;
var peers : Array[Player];


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
	has_connection = true;
	established_connection.emit();
	return true;


func stop() -> void:
	if socket == null: return;
	has_connection = false;
	socket.close();
	while socket.get_ready_state() != socket.STATE_CLOSED:
		await get_tree().create_timer(1.0).timeout;
		socket.poll();
	socket = null;
	lost_connection.emit();


func send(mtype : Server.Message_Type, payload : PackedByteArray = PackedByteArray()) -> bool:
	if !has_connection: return false;
	var msg : PackedByteArray = PackedByteArray();
	msg.append(mtype);
	msg.append_array(payload);
	socket.send(msg);
	return true;


func _process(_dt : float) -> void:
	if socket != null: socket.poll()
	
	if !has_connection: return;
	
	# Process packets
	if socket.get_ready_state() == WebSocketPeer.STATE_OPEN:
		while socket.get_available_packet_count():
			var msg : PackedByteArray = socket.get_packet();
			var mtype : int = msg[0];
			var payload : PackedByteArray = msg.slice(1);
			match mtype:
				Message_Type.CHANGELEVEL: Message_Bus.change_level_requested.emit(payload.get_string_from_ascii(), self);
				Message_Type.PEER_CONNECTED: create_peer(payload.decode_s8(0));
				Message_Type.PEER_DISCONNECTED: remove_peer(payload.decode_s8(0));
				Message_Type.PEER_UPDATE: update_peer(bytes_to_var_with_objects(payload));
				_:
					print("CLIENT - UNKNOWN MESSAGE CODE %d" % mtype);
	else:
		print("Lost connection to server");
		stop();


func create_peer(id : int):
	print("create_peer %d" % id);


func remove_peer(id : int):
	print("remove_peer %d" % id);


func update_peer(pp : Player_Packet):
	Globals.debug_panel.add_property("PEER %d POS" % pp.pid, str(pp.position));
