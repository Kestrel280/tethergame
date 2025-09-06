class_name Server
extends Node

var tcp_server : TCPServer = TCPServer.new();
var players : Dictionary;
var _id : int = 0;


enum Message_Type {
	PLAYER_PACKET,
	PLAYER_TOGGLED_MOVE_MODE,
	PLAYER_TOGGLED_VIEW_MODE,
	PLAYER_CHANGED_WEAPON,
	DEBUG,
	UNHANDLED
}


class Player_Connection:
	var id : int;
	var socket : WebSocketPeer;
	var player : Player;


func start():
	if tcp_server.listen(Globals.server_port) != OK: assert(false, "Failed to start TCP server");
	Message_Bus.change_level_requested.emit("test_level_6");
	print("Server running on port %d" % Globals.server_port);


func _process(_delta: float) -> void:
	# Accept new connections
	while tcp_server.is_connection_available():
		var conn: StreamPeerTCP = tcp_server.take_connection();
		assert(conn != null);
		register_player(conn);
	
	for pid : int in players.keys():
		var pc : Player_Connection = players[pid];
		# Poll socket to keep up to date
		pc.socket.poll();
		if pc.socket.get_ready_state() != WebSocketPeer.STATE_OPEN:
			deregister_player(pid);
			continue;
		while pc.socket.get_available_packet_count():
			var msg : PackedByteArray = pc.socket.get_packet();
			var mtype : int = msg[0];
			var payload : PackedByteArray = msg.slice(1);
			match mtype:
				Message_Type.PLAYER_PACKET:
					var pp : Player_Packet = bytes_to_var_with_objects(payload);
					pc.player.get_node("Camera_Controller").look_at(-pp.look_basis.z);
					pc.player.get_node("Input_Controller").inject(pp.input_dir, pp.jumping, pp.crouching, pp.shooting, pp.interacting);
				Message_Type.PLAYER_TOGGLED_MOVE_MODE:
					pc.player.on_input_controller_pressed_toggle_movemode();
					print("Player toggled move mode");
				Message_Type.PLAYER_TOGGLED_VIEW_MODE:
					print("Player toggled view mode");
					pc.player.on_input_controller_pressed_toggle_viewmode();
				Message_Type.PLAYER_CHANGED_WEAPON:
					var wep : int = payload.decode_s32(0);
					print(payload);
					print("Player %d changed weapon to %d" % [pid, wep]);
					pc.player.on_input_controller_pressed_change_weapon(wep);
				Message_Type.DEBUG:
					print("DEBUG msg received from client %d: Input dir is %s, view dir is %s" % [pid, str(pc.player.get_player_data().input_dir), str(-pc.player.get_player_data().look_basis.z)]);
				_:
					print("Unknown message type %d received from client %d" % [mtype, pid]);


func register_player(conn : StreamPeerTCP) -> int:
	_id += 1;
	var pid : int = _id;
	var socket : WebSocketPeer = WebSocketPeer.new();
	socket.accept_stream(conn);
	players[pid] = Player_Connection.new();
	players[pid].socket = socket;
	var p : Player = Player.construct();
	Globals.level.add_child(p);
	var inpctl : Input_Controller_Base = Input_Controller_Remote.new();
	p.swap_controller(inpctl);
	players[pid].player = p;
	print("Player %d connected and registered" % _id);
	return pid;


func deregister_player(player_id : int):
	print("Player %d disconnected" % player_id);
	players[player_id].player.queue_free();
	players[player_id].socket.close();
	players.erase(player_id);
