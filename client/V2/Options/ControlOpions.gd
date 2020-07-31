extends Control

func _ready():
	$FadeIn.fade_out()

func _on_Button_pressed():
	$FadeIn.show()
	$FadeIn.fade_in()


func _on_FadeIn_fade_finished():
	$FadeIn.fade_out()
#	$FadeIn.hide()
	global.change_scene(global.controlMenuNode)


func _on_FadeIn_fade_out_finished():
	$FadeIn.hide()
