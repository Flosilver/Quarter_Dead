extends Control

var explorerColor=[Color(255,0,0),Color(0,255,0),Color(0,0,255),Color(255,255,0)]
# chemins vers les différents des objets rooms
var objRooms=[
	#00
	"res://obj/sallesw.obj",
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
	"res://tiles/Texture/texture2.png",
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
	[0.5,-0.5],
	[-0.5,-0.5],
]

# liste contenant les pointeurs vers les 5 nodes exit crées
var lExplos=[null,null,null,null]
var campx
var campy

var maze
const roomOff = 3.5

# Called when the node enters the scene tree for the first time.
func _ready():

	campx=-5
	campy=-5
	var i = global.direction
	lExplos[i]=createExplorer(campx+lOffsetExplo[i][0], campy+lOffsetExplo[i][1],i)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _networkMessage(mess):
	print ("_networkMessage=",mess)
	match mess[0]:
		'c': # créer un explorateur et le mettre à sa position en attendant tout le monde
			var dir=int(mess[1])
			if global.playersPresent[dir]==0:
				global.playersPresent[dir]=1
#				var x=lOffsetExplo[dir][0]
#				var y=lOffsetExplo[dir][1]
#				lExplos[dir]=createExplorer(x+campx,y+campy,dir)

		'm':	# récupère les variable des dimensions du jeu
			global.nb_etages = int(mess[1])
			global.map_size = int(mess[2])
			maze = []
			print("création de la map")
			for i in range(global.nb_etages):
				print("création de l'étage ", i)
				maze.push_back([])
				for j in range(global.map_size):
					maze[i].push_back([])
					for k in range(global.map_size):
						maze[i][j].append(0)
				print("étage ", i, " x=", maze[i].size(), " y=", maze[i][0].size())
			print("nb_étages créés: ",maze.size())
			
		'g': # génération d'un étage
			# indice de la room à générer
			var idr = 2
			# étage a construire
			var etage = int(mess[1])
			for i in range(global.map_size):
				for j in range(global.map_size):
					maze[etage][i][j] = int(mess[idr])
					#print(maze[etage][i][j])
					idr += 1
			buildMaze(etage)
			
		'p': # placement des pions
			var y = int(mess[1])
			var x = int(mess[2])
			for i in range(global.NB_J):
				lExplos[i].set_translation(Vector3((x*2*roomOff)+lOffsetExplo[i][0],0,(y*2*roomOff)+lOffsetExplo[i][1]))
			var cam=get_tree().get_root().get_node("ControlGame").get_node("Spatial").get_node("Camera")
			cam.set_translation(Vector3(x*2*roomOff,3,(y*2*roomOff)+2))
	
func createRoom(x,y,room_num):
	# Create a new tile instance
	var mi=MeshInstance.new()
	# and translate it to its final position
	mi.set_translation(Vector3(x,0,y))
	# load the room mesh
	var meshObj=load(objRooms[0])#->load(objRooms[room_num])
	# and assign the mesh instance with it
	mi.mesh=meshObj
	# create a new spatial material for the tile
#	var spatial_material=SpatialMaterial.new()
#	# and assign the material to the mesh instance
#	mi.set_surface_material(0,spatial_material)
#	# create a new image texture that will be used as a room texture
#	var texture=ImageTexture.new()
#	texture.load("res://tiles/Texture/texture2.png")#(tileRooms[room_num])
#	# and perform the assignment to the surface_material
#	spatial_material.albedo_texture=texture
	# add the newly created instance as a child of the Origine3D Node
	$Spatial.add_child(mi)
	return mi
	
func createExplorer(x,y,num):
	# Create a new tile instance
	var mi=MeshInstance.new()
	# and translate it to its final position
	mi.set_translation(Vector3(x,0,y))
	mi.set_rotation(Vector3(0,-PI/2.0,0))
	mi.set_scale(Vector3(0.5,0.5,0.5))
	# load the tile mesh
	var meshObj=load("res://obj/robot.obj")
	# and assign the mesh instance with it
	mi.mesh=meshObj
	# create a new spatial material for the tile
	var surface_material=SpatialMaterial.new()
	# set its color
	# surface_material.albedo_color=explorerColor[num]
	# and assign the material to the mesh instance
	mi.set_surface_material(0,surface_material)
	
	var texture = ImageTexture.new()
	texture.load("res://tiles/Texture/textureRobot1.0.png")
	surface_material.albedo_texture=texture
	# add the newly created instance as a child of the Origine3D Node
	$Spatial.add_child(mi)
	return mi

func buildMaze(etage):
	print("construction du terrain")
	
	for i in range(global.map_size):
		for j in range(global.map_size):
			createRoom(2*i*roomOff,2*j*roomOff,maze[etage][i][j])

func _on_ButtonMenu_pressed():
	var root=get_tree().get_root()
	var myself=root.get_child(1)
	print (root,myself)
	root.remove_child(myself)
	root.add_child(global.controlMenuNode)


func _on_ButtonC1_pressed():
	var connectMessage="C1"
	print("bouton c1 pressé")
	global.mplayer.send_bytes(connectMessage.to_ascii())
	var i = 1
	if global.playersPresent[i] == 0:
		print("création d'un nouveau explorateur")
		lExplos[i]=createExplorer(campx+lOffsetExplo[i][0], campy+lOffsetExplo[i][1],i)


func _on_ButtonC2_pressed():
	var connectMessage="C2"
	print("bouton c1 pressé")
	global.mplayer.send_bytes(connectMessage.to_ascii())
	var i = 2
	if global.playersPresent[i] == 0:
		print("création d'un nouveau explorateur")
		lExplos[i]=createExplorer(campx+lOffsetExplo[i][0], campy+lOffsetExplo[i][1],i)


func _on_ButtonC3_pressed():
	var connectMessage="C3"
	print("bouton c1 pressé")
	global.mplayer.send_bytes(connectMessage.to_ascii())
	var i = 3
	if global.playersPresent[i] == 0:
		print("création d'un nouveau explorateur")
		lExplos[i]=createExplorer(campx+lOffsetExplo[i][0], campy+lOffsetExplo[i][1],i)
