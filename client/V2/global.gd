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

var nb_etages
var map_size

var vise = 0
var level = 0

const NB_J=4

func _ready():
	controlMenuNode=null
	controlGameNode=null
	controlOptionsNode=null
	controlSplashNode=null
	nb_etages = 0
	map_size = 0
	direction=-1
	serverAddress="errorServerAddress"
	print("global _ready() called")
	pass 
