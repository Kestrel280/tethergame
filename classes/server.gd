class_name Server
extends Node

var tcp_server : TCPServer = TCPServer.new();
var players : Dictionary;
var _id : int = 0;
var level : String;


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
	var physics_queue : Array[Player_Packet];
	
	func send(mtype : Server.Message_Type, payload : PackedByteArray = PackedByteArray()) -> bool:
		var msg : PackedByteArray = PackedByteArray();
		msg.append(mtype);
		msg.append_array(payload);
		socket.send(msg);
		return true;


func start(_level : String = "test_level_6"):
	level = _level;
	if tcp_server.listen(Globals.server_port) != OK: assert(false, "Failed to start TCP server");
	Message_Bus.change_level_requested.emit(_level);
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
					pc.physics_queue.push_back(pp);
				Message_Type.PLAYER_TOGGLED_MOVE_MODE:
					pc.player.toggle_movemode();
					print("Player toggled move mode");
				Message_Type.PLAYER_TOGGLED_VIEW_MODE:
					print("Player toggled view mode");
					pc.player.toggle_viewmode();
				Message_Type.PLAYER_CHANGED_WEAPON:
					var wep : int = payload.decode_s8(0);
					print(payload);
					print("Player %d changed weapon to %d" % [pid, wep]);
					pc.player.change_weapon(wep);
				Message_Type.DEBUG:
					print("DEBUG msg received from client %d: Input dir is %s, view dir is %s, pos is %s, velocity is %s" % [pid, str(pc.player.get_player_data().input_dir), str(-pc.player.get_player_data().look_basis.z), str(pc.player.get_player_data().position), str(pc.player.get_player_data().velocity)]);
				_:
					print("Unknown message type %d received from client %d" % [mtype, pid]);


func _physics_process(_dt : float):
	# Tick each player using queued physics update
	for pid : int in players.keys():
		var pc : Player_Connection = players[pid];
		while !pc.physics_queue.is_empty():
			var pp : Player_Packet = pc.physics_queue.pop_front();
			pc.player.get_node("Camera_Controller").look_at(-pp.look_basis.z);
			pc.player.get_node("Input_Controller").inject(pp.input_dir, pp.jumping, pp.crouching, pp.shooting, pp.interacting);
			pc.player.tick(pp.tick_dt);
			
			# Send updated player data to each other peer
			pp = pc.player.get_player_data(_dt); # Re-using pp
			pp.pid = pid;
			for peer_pid : int in players.keys():
				if peer_pid == pid: continue;
				players[peer_pid].send(Client.Message_Type.PEER_UPDATE, var_to_bytes_with_objects(pp));


func register_player(conn : StreamPeerTCP) -> int:
	# A new player has connected
	# Assign them an ID
	_id += 1;
	var pid : int = _id;
	
	# Create a persistent socket for them
	var socket : WebSocketPeer = WebSocketPeer.new();
	socket.accept_stream(conn);
	while socket.get_ready_state() != socket.STATE_OPEN:
		await get_tree().create_timer(1.0).timeout;
		socket.poll();
	
	# Register them in our players list
	players[pid] = Player_Connection.new();
	players[pid].socket = socket;
	
	# Tell them to change to our level
	players[pid].send(Client.Message_Type.CHANGELEVEL, level.to_ascii_buffer());
	
	# Create a new Player instance to represent them, and install our Remote input controller
	var p : Player = Player.construct();
	add_child(p);
	var inpctl : Input_Controller_Base = Input_Controller_Remote.new();
	p.swap_controller(inpctl);
	players[pid].player = p;
	print("Player %d connected and registered" % _id);
	
	# Inform other peers of new player, and inform the new player of each existing player
	for peer_pid : int in players.keys():
		if pid == peer_pid: continue;
		players[pid].send(Client.Message_Type.PEER_CONNECTED, PackedByteArray([peer_pid]));
		players[peer_pid].send(Client.Message_Type.PEER_CONNECTED, PackedByteArray([pid]));
	return pid;


func deregister_player(pid : int):
	print("Player %d disconnected" % pid);
	players[pid].player.queue_free();
	players[pid].socket.close();
	players.erase(pid);
	print(players);
	for peer_pid : int in players.keys():
		players[peer_pid].send(Client.Message_Type.PEER_DISCONNECTED, PackedByteArray([pid]));
