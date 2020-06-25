extends Node

var mode
var network
var mplayer

var controlMenuNode
var controlGameNode
var controlOptionsNode
var controlSplashNode
var direction
var serverAddress

var previous
var current

var playersPresent=[0,0,0,0]


func _ready():
	controlMenuNode=null
	controlGameNode=null
	controlOptionsNode=null
	controlSplashNode=null
	direction=-1
	serverAddress="errorServerAddress"
	print("global _ready() called")
	pass 
