extends ColorRect


signal fade_finished

func fade_in():
	$fade_in.play("fade_in")

func fade_out():
	$fade_out.play("fade_out")

func _on_fade_in_animation_finished(anim_name):
	emit_signal("fade_finished")
