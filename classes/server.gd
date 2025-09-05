class_name Server
extends Node

var tcp_server : TCPServer = TCPServer.new();
var players : Dictionary;
var _id : int = 0;


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
			var pp : Player_Packet = bytes_to_var_with_objects(pc.socket.get_packet());
			print(pp.position);


func register_player(conn : StreamPeerTCP) -> int:
	_id += 1;
	var pid : int = _id;
	var socket : WebSocketPeer = WebSocketPeer.new();
	socket.accept_stream(conn);
	players[pid] = Player_Connection.new();
	players[pid].socket = socket;
	var p : Player = Player.construct();
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
