extends Node

var mode
var network
var mplayer

var controlMenuNode
var controlConnexionNode
var controlGameNode
var controlOptionsNode
var controlSplashNode
var controlEndNode
var direction
var serverAddress

var previous
var current

var playersPresent=[0,0,0,0]

var nb_etages
var map_size
var etat

var vise = 0
var level = 0

const NB_J=4

func _ready():
	controlMenuNode=null
	controlConnexionNode = null
	controlGameNode=null
	controlOptionsNode=null
	controlSplashNode=null
	controlEndNode=null
	nb_etages = 0
	map_size = 0
	etat = 0
	direction=-1
	serverAddress="errorServerAddress"
	print("global _ready() called")
	pass 

func change_scene(new_scene):
	var root=get_tree().get_root()
	var myself=root.get_child(1)
	print (root,myself)
	root.remove_child(myself)
	root.add_child(new_scene)
