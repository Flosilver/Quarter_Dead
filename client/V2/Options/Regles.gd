extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$FadeIn.show()
	$FadeIn.fade_out()


func _on_FadeIn_fade_out_finished():
	$FadeIn.hide()


func _on_BackButton_pressed():
	$FadeIn.show()
	$FadeIn.fade_in()


func _on_FadeIn_fade_finished():
	$FadeIn.fade_out()
	global.change_scene(global.controlOptionsNode)
