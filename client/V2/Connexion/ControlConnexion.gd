extends Control

var next_scene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_MenuPrincipalButton_pressed():
	next_scene = global.controlMenuNode
	$FadeIn.show()
	$FadeIn.fade_in()


func _on_FadeIn_fade_finished():
	$FadeIn.fade_out()
	$FadeIn.hide()
	global.change_scene(next_scene)
