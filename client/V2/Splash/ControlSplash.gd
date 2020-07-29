extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	global.controlMenuNode = load("res://Menu/ControlMenu.tscn").instance()
	global.controlConnexionNode = load("res://Connexion/ControlConnexion.tscn").instance()
	global.controlGameNode=load("res://Game/ControlGame.tscn").instance()
	global.controlOptionsNode = load("res://Options/ControlOpions.tscn").instance()
	
	var f=File.new()
	f.open("user://direction.txt", File.READ)
	var content = f.get_as_text()
	f.close()
	global.direction=int(content[0])
	print("direction=",global.direction)
	f=File.new()
	f.open("user://server.txt", File.READ)
	content= f.get_as_text()
	f.close()
	global.serverAddress=content.strip_edges()
	print("serverAddress={",global.serverAddress,"}")
	
	print ("controlMenuNode=",global.controlMenuNode)
	print ("controlConnexionNode=", global.controlConnexionNode)
	print ("controlGameNode=",global.controlGameNode)
	print ("controlOptionsNode=",global.controlOptionsNode)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_PlayButton_pressed():
	$FadeIn.show()
	$FadeIn.fade_in()

func _on_FadeIn_fade_finished():
	global.change_scene(global.controlMenuNode)
	global.controlMenuNode.installNetworkCallback()
