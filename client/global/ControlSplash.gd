extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	global.controlMenuNode=load("res://ControlMenu.tscn").instance()
	global.controlGameNode=load("res://ControlGame.tscn").instance()
	global.controlOptionsNode=load("res://ControlOptions.tscn").instance()
	
#	var f=File.new()
#	f.open("user://direction.txt", File.READ)
#	var content = f.get_as_text()
#	f.close()
#	global.direction=int(content[0])
#	print("direction=",global.direction)
#	f=File.new()
#	f.open("user://server.txt", File.READ)
#	content= f.get_as_text()
#	f.close()
#	global.serverAddress=content.strip_edges()
	global.serverAddress = "192.168.1.12"
	print("serverAddress={",global.serverAddress,"}")
	
	print ("controlMenuNode=",global.controlMenuNode)
	print ("controlGameNode=",global.controlGameNode)
	print ("controlOptionsNode=",global.controlOptionsNode)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_ButtonVersMenu_pressed():
	var root=get_tree().get_root()
	var myself=root.get_child(1)
	print (root,myself)
	root.remove_child(myself)
	root.add_child(global.controlMenuNode)
	global.controlMenuNode.installNetworkCallback()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#       pass

