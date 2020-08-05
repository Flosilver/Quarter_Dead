extends MeshInstance


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func set_name(name):
	var spatial_material=SpatialMaterial.new()
	$name.set_surface_material(0,spatial_material)
	var tx = ImageTexture.new()
	var path = "res://tiles/Connexion/" + name + ".png"
#	print("path: ", path, "\texpected: res://tiles/Connexion/J1.png")
	tx.load(path)
	spatial_material.set_billboard_mode(SpatialMaterial.BILLBOARD_ENABLED)
	spatial_material.flags_transparent = true
	# and perform the assignment to the surface_material
	spatial_material.albedo_texture=tx
