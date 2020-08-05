extends Control

var next_scene

var commandeNode
var reglesNode

func _ready():
	$FadeIn.show()
	$FadeIn.fade_out()
	commandeNode = load("res://Options/Commandes.tscn").instance()
	reglesNode = load("res://Options/Regles.tscn").instance()


func _on_FadeIn_fade_finished():
	$FadeIn.fade_out()
#	$FadeIn.hide()
	global.change_scene(next_scene)


func _on_FadeIn_fade_out_finished():
	$FadeIn.hide()


func _on_BackButton_pressed():
	$FadeIn.show()
	$FadeIn.fade_in()
	next_scene = global.controlMenuNode


func _on_CommandeButton_pressed():
	$FadeIn.show()
	$FadeIn.fade_in()
	next_scene = commandeNode


func _on_ReglesButton_pressed():
	$FadeIn.show()
	$FadeIn.fade_in()
	next_scene = reglesNode
