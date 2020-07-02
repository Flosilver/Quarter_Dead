extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func installNetworkCallback():
	global.network=NetworkedMultiplayerENet.new()
	global.network.create_client(global.serverAddress,4242)
	get_tree().set_network_peer(global.network)
	global.mplayer=get_tree().multiplayer
	global.mplayer.connect("network_peer_packet",self,"_on_packet_received")
	#connect("network_peer_packet",self,"_on_packet_received")
	
func _on_ButtonJouer_pressed():
	var root=get_tree().get_root()
	var myself=root.get_child(1)
	print (root,myself)
	root.remove_child(myself)
	root.add_child(global.controlGameNode)
	
	var connectMessage="C"+str(global.direction)
	global.mplayer.send_bytes(connectMessage.to_ascii())

	connectMessage="C1"
	global.mplayer.send_bytes(connectMessage.to_ascii())
	connectMessage="C2"
	global.mplayer.send_bytes(connectMessage.to_ascii())
	connectMessage="C3"
	global.mplayer.send_bytes(connectMessage.to_ascii())

func _on_ButtonOptions_pressed():
	var root=get_tree().get_root()
	var myself=root.get_child(1)
	print (root,myself)
	root.remove_child(myself)
	root.add_child(global.controlOptionsNode)

func _on_packet_received(id, packet):
	var mess=packet.get_string_from_ascii()
	#print (mess)
	global.controlGameNode._networkMessage(mess)

func _on_ButtonTestReseau_pressed():
	#get_tree().multiplayer.send_bytes("ABCDEFGH".to_ascii())
	global.mplayer.send_bytes("ABCDEFGH".to_ascii())
	pass # Replace with function body.
