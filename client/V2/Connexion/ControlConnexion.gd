extends Control

var next_scene

var new_player = [null, null, null, null]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func add_new_player(num):	
	print("ajout du player: ", num)
	# instanciation du nouveau player
	var np = load("res://Connexion/NewPlayer.tscn").instance()
	# positionnement adéquat
	np.translation.x = num
	# initialisation du nom
	var name = "J" + str(num+1)
	np.set_name(name)
	# ajout à la scene
	$Scene.add_child(np)
	new_player[num] = np
	
	# ajout dans le jeu
	global.controlGameNode.add_player(num)

func remove_new_player(num):
	$Scene.remove_child(new_player[num])
	new_player[num] = null
	
	# suppression dans le jeu
	global.controlGameNode.remove_player(num)

func start_game():
	next_scene = global.controlGameNode
	$FadeIn.show()
	$FadeIn.fade_in()

func _on_MenuPrincipalButton_pressed():
	next_scene = global.controlMenuNode
	remove_new_player(global.direction)
	$FadeIn.show()
	$FadeIn.fade_in()
	
	var disconnectMessage = "D" + str(global.direction)
	global.mplayer.send_bytes(disconnectMessage.to_ascii())
	


func _on_FadeIn_fade_finished():
	$FadeIn.fade_out()
	$FadeIn.hide()
	global.change_scene(next_scene)


func _on_ButtonC1_pressed():
	if global.playersPresent[1] == 0:
		var connectMessage="C"+str(1)
		global.mplayer.send_bytes(connectMessage.to_ascii())
	else:
		var disconnectMessage = "D" + str(1)
		global.mplayer.send_bytes(disconnectMessage.to_ascii())


func _on_ButtonC2_pressed():
	if global.playersPresent[2] == 0:
		var connectMessage="C"+str(2)
		global.mplayer.send_bytes(connectMessage.to_ascii())
	else:
		var disconnectMessage = "D" + str(2)
		global.mplayer.send_bytes(disconnectMessage.to_ascii())


func _on_ButtonC3_pressed():
	if global.playersPresent[3] == 0:
		var connectMessage="C"+str(3)
		global.mplayer.send_bytes(connectMessage.to_ascii())
	else:
		var disconnectMessage = "D" + str(3)
		global.mplayer.send_bytes(disconnectMessage.to_ascii())
