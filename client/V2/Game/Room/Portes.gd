extends Spatial

signal anim_doors_finished


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func open_doors():
	$OpenDoors.play()

func open_glass():
	$OpenGlass.play()

func close_glass():
	$CloseGlass.play()

func ban():
	var new_spatial_material = load("res://Game/Room/PortesGaucheBannedTx.tres")
	$PorteGauche.set_surface_material(0,new_spatial_material)

func _on_OpenDoors_animation_finished(anim_name):
	emit_signal("anim_doors_finished")


func _on_OpenGlass_animation_finished(anim_name):
	emit_signal("anim_doors_finished")


func _on_CloseGlass_animation_finished(anim_name):
	emit_signal("anim_doors_finished")
