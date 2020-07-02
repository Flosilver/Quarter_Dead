extends Control

var explorerColor=[Color(255,0,0),Color(0,255,0),Color(0,0,255),Color(255,255,0)]
# chemins vers les différents des objets rooms
var objRooms=[
	#00
	"res://obj/",
	#01
	"res://obj/", 
	#02
	"res://obj/", 
	#03
	"res://obj/", 
	#04
	"res://obj/", 
	#05
	"res://obj/", 
	#06
	"res://obj/", 
]
# chemins vers les textures associées aux rooms
var tileRooms=[
	 #00
	"res://tiles/Texture/",
	#01
	"res://tiles/Texture/", 
	#02
	"res://tiles/Texture/", 
	#03
	"res://tiles/Texture/", 
	#04
	"res://tiles/Texture/", 
	#05
	"res://tiles/Texture/", 
	#06
	"res://tiles/Texture/", 
]

var lOffsetExplo=[
	[-0.5,0.5],
	[0.5,0.5],
	[0.5,-1.5],
	[-0.5,-0.5],
]

var grotteIndexes=[0,0,0,0,0]

# liste contenant les pointeurs vers les 5 nodes exit crées
var lExits=[null,null,null,null,null]
var lGrotteNodes
var lGems
var lExplos=[null,null,null,null]
var campx
var campy

# Called when the node enters the scene tree for the first time.
func _ready():

	campx=0
	campy=0
	
	for i in range(4):
		lExplos[i]=createExplorer(campx+lOffsetExplo[i][0],
			campy+lOffsetExplo[i][1],i)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _networkMessage(mess):
	print ("_networkMessage=",mess)
	match mess[0]:
		'C': # créer un explorateur et le mettre à sa position dans le campement
			var dir=int(mess[1])
			if global.playersPresent[dir]==0:
				global.playersPresent[dir]=1
				var x=lOffsetExplo[dir][0]
				var y=lOffsetExplo[dir][1]
				lExplos[dir]=createExplorer(x+campx,y+campy,dir)

func _on_ButtonMenu_pressed():
	var root=get_tree().get_root()
	var myself=root.get_child(1)
	print (root,myself)
	root.remove_child(myself)
	root.add_child(global.controlMenuNode)
	
func createTile(x,y,room_num):
	# Create a new tile instance
	var mi=MeshInstance.new()
	# and translate it to its final position
	mi.set_translation(Vector3(x,0,y))
	# load the tile mesh
	var meshObj=load("TODO")
	# and assign the mesh instance with it
	mi.mesh=meshObj
	# create a new spatial material for the tile
	var surface_material=SpatialMaterial.new()
	# and assign the material to the mesh instance
	mi.set_surface_material(0,surface_material)
	# create a new image texture that will be used as a tile texture
	var texture=ImageTexture.new()
	texture.load(tileRooms[room_num])
	# and perform the assignment to the surface_material
	surface_material.albedo_texture=texture
	# add the newly created instance as a child of the Origine3D Node
	$Spatial.add_child(mi)
	return mi
	
func createExplorer(x,y,num):
	# Create a new tile instance
	var mi=MeshInstance.new()
	# and translate it to its final position
	mi.set_translation(Vector3(x,0,y))
	mi.set_rotation(Vector3(0,PI/2.0,0))
	mi.set_scale(Vector3(0.5,0.5,0.5))
	# load the tile mesh
	var meshObj=load("TODO")
	# and assign the mesh instance with it
	mi.mesh=meshObj
	# create a new spatial material for the tile
	var surface_material=SpatialMaterial.new()
	# set its color
	surface_material.albedo_color=explorerColor[num]
	# and assign the material to the mesh instance
	mi.set_surface_material(0,surface_material)
	# add the newly created instance as a child of the Origine3D Node
	$Spatial.add_child(mi)
	return mi
