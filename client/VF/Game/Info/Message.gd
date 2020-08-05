extends CenterContainer

func _ready():
	$FadeIn.show()
	$FadeIn.fade_out()

func set_text(txt):
	$Message.set_text(txt)


func _on_FadeIn_fade_out_finished():
	yield(get_tree().create_timer(2.0), "timeout")
	$FadeIn.fade_in()


func _on_FadeIn_fade_finished():
	queue_free()
