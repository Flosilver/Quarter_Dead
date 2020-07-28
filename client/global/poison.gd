extends Spatial


# Called when the node enters the scene tree for the first time.
func _ready():
	yield(get_tree().create_timer(5.0), "timeout")
	queue_free()
