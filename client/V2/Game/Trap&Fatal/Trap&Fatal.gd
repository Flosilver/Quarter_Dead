extends Spatial

export(Vector3) var pos
signal trap_anim_finished


# Called when the node enters the scene tree for the first time.
func _ready():
	yield(get_tree().create_timer(5.0), "timeout")
	queue_free()
	emit_signal("trap_anim_finished")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
