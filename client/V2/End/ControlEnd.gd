extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$FadeIn.show()
	$FadeIn.fade_out()


func set_text(txt):
	$CenterContainer/Message.set_text(txt)

func _on_FadeIn_fade_finished():
	$FadeIn.fade_out()
#	$FadeIn.hide()
	global.change_scene(global.controlSplashNode)
	
	var disconnectMessage = "D" + str(global.direction)
	global.mplayer.send_bytes(disconnectMessage.to_ascii())


func _on_FadeIn_fade_out_finished():
	$FadeIn.hide()


func _on_EndButton_pressed():
	$FadeIn.show()
	$FadeIn.fade_in()
