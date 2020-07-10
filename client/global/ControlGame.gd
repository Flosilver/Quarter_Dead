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
]
# textures des rooms
var txRooms=[
	#00
	null,
	#01
	null, 
	#02
	null, 
	#03
	null, 
	#04
	null, 
	#05
	null, 
]
var objDoors=[
	#00
	"res://obj/Porte1.obj",
	#01
	"res://obj/Porte2.obj", 
	#02
	"res://obj/PorteVerre.obj",
	#03
	"res://obj/Vitre.obj"
]
var tileDoors=[
	#00
	"res://tiles/Texture/texturePorte1.0.png",
	#01
	"res://tiles/Texture/texturePorte2.0.png", 
	#02
	"res://tiles/Texture/texturePorteVerre.0.png",
	#03
	"res://tiles/Texture/"
]
var txDoors=[
	#00
	null,
	#01
	null, 
	#02
	null,
	#03
	null
]

var lOffsetExplo=[
	[-0.5,0.5],
	[0.5,0.5],
	[0.5,-0.5],
	[-0.5,-0.5],
]

# liste contenant les pointeurs vers les 5 nodes exit crées
var lExplos=[null,null,null,null]
var objExplo=[
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
	"res://obj/robot001.obj",
	#07
	"res://obj/",
	#08 : obj du modèle temporaire pour la connexion
	"res://obj/Personnage.obj"
]
var tileExplo=[
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
	"res://tiles/Texture/textureRobot1.0.png",
	#07
	"res://tiles/Texture/",
	#08 : chemin de la texture pour le modèle temporaire
	"res://tiles/Texture/texturePersonnage.jpg"
]
var txExplo=[
	#00
	null,
	#01
	null, 
	#02
	null, 
	#03
	null, 
	#04
	null, 
	#05
	null,
	#06
	null,
	#07
	null,
	#08 : texture du modèle temporaire
	null
]

var campx
var campy
var pressed=[0,0,0,0,0,
	0,0,0,0,0,
	0,0,0,0,0,
	0,0,0,0,0,
	]

var maze
const roomOff = 3.5

# Called when the node enters the scene tree for the first time.
func _ready():

	campx=-5
	campy=-5
	var i = global.direction
	lExplos[i]=createExplorer(campx+lOffsetExplo[i][0], campy+lOffsetExplo[i][1],i,8)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	if Input.get_connected_joypads().size() > 0:
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
					for _k in range(global.map_size):
						maze[i][j].append(null)
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
			#createRoom(0,0,0)
			
		'p': # placement des pions
			var y = int(mess[1])
			var x = int(mess[2])
#			x = 0
#			y = 0
			for i in range(global.NB_J):
				lExplos[i].set_translation(Vector3((x*2*roomOff)+lOffsetExplo[i][0],0,(y*2*roomOff)+lOffsetExplo[i][1]))
			var cam=get_tree().get_root().get_node("ControlGame").get_node("Spatial").get_node("Camera")
			cam.set_translation(Vector3(x*2*roomOff,2,(y*2*roomOff)))
			
		'r': # distribution des rôles
			var xtemp
			var ytemp
			var ztemp
			for i in range(global.NB_J):
				xtemp = lExplos[i].translation.x
				ytemp = lExplos[i].translation.y
				ztemp = lExplos[i].translation.z
				lExplos[i] = createExplorer(xtemp,ztemp,i,6)#mess[i+1])
				lExplos[i].set_translation(Vector3(xtemp,ytemp,ztemp))

func createRoom(x,y,room_num):
	# Create a new tile instance
	room_num = 0
	var mi=MeshInstance.new()
	# and translate it to its final position
	mi.set_translation(Vector3(x,0,y))
	# load the room mesh
	var meshObj=load(objRooms[room_num])
	# and assign the mesh instance with it
	mi.mesh=meshObj
	# create a new spatial material for the tile
	var spatial_material=SpatialMaterial.new()
	# and assign the material to the mesh instance
	mi.set_surface_material(0,spatial_material)
	# create a new image texture if not already created that will be used as a room texture
	if txRooms[room_num] == null:
		txRooms[room_num] = ImageTexture.new()
		txRooms[room_num].load(tileRooms[room_num])
	# and perform the assignment to the surface_material
	spatial_material.albedo_texture=txRooms[room_num]
	
	#ajout des portes
	var distP = 3.3		#distance pour les portes
	var distV = 3.5		#distance pour les portes en verre
	var ppos = Vector3(0,0,0)		# vecteur de position des portes
	var vpos = Vector3(0,0,0)		# vecteur de position de la porte vitrée
	var pg		# porte de gauche
	var pd		# porte de droite
	var pv		# porte de verre
	var v		# vitre
	var portes = [pg, pd, pv, v]
	var txpg	# texture porte de gauche
	var txpd	# texture porte de droite
	var txpv	# texture porte de verre
	var txv		# texture vitre
	var tx_portes = [txpg, txpd, txpv, txv]
	for i in range(4):
		ppos = Vector3(0,0,0)		# vecteur de position des portes
		vpos = Vector3(0,0,0)		# vecteur de position de la porte vitrée
		# adaptation des position
		match i:
			0:
				ppos.x = -distP
				vpos.x = -distV
			1:
				ppos.z = distP
				vpos.z = distV
			2:
				ppos.x = distP
				vpos.x = distV
			3:
				ppos.z = -distP
				vpos.z = -distV
		for j in range(4):
			# création de la Mesh
			portes[j] = MeshInstance.new()
			# positionnement de la Mesh
			if (j<2):
				portes[j].set_translation(ppos)
			else:
				portes[j].set_translation(vpos)
			portes[j].set_rotation(Vector3(0,i*PI/2,0))
			# load du modèle
			portes[j].mesh = load(objDoors[j])
			#instanciation de la texture
			tx_portes[j] = SpatialMaterial.new()
			# assignation de la texture
			portes[j].set_surface_material(0,tx_portes[j])
			# chargement de la texture
			if txDoors[j] == null:
				txDoors[j] = ImageTexture.new()
				txDoors[j].load(tileDoors[j])
			# and perform the assignment to the surface_material
			tx_portes[j].albedo_texture=txDoors[j]
			mi.add_child(portes[j])
	
	# add the newly created instance as a child of the Origine3D Node
	$Spatial.add_child(mi)
	return mi
	
func createExplorer(x,y,who,role):
	if lExplos[who] != null:
		print("remplacement du personnage")
		$Spatial.remove_child(lExplos[who])
	
	# Create a new tile instance
	var mi=MeshInstance.new()
	# and translate it to its final position
	mi.set_translation(Vector3(x,0,y))
	mi.set_rotation(Vector3(0,0,0))
	# load the tile mesh
	var meshObj=load(objExplo[role])
	# and assign the mesh instance with it
	mi.mesh=meshObj
	# create a new spatial material for the tile
	var spatial_material=SpatialMaterial.new()
	# set its color
	# surface_material.albedo_color=explorerColor[num]
	# and assign the material to the mesh instance
	mi.set_surface_material(0,spatial_material)
	if txExplo[role] == null:
		txExplo[role] = ImageTexture.new()
		txExplo[role].load(tileExplo[role])
	# and perform the assignment to the surface_material
	spatial_material.albedo_texture=txExplo[role]
	# add the newly created instance as a child of the Origine3D Node
	$Spatial.add_child(mi)
	return mi

func buildMaze(etage):
	print("construction du terrain")
	
	for i in range(global.map_size):
		for j in range(global.map_size):
			maze[etage][i][j] = createRoom(2*i*roomOff,2*j*roomOff,maze[etage][i][j])

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
		lExplos[i]=createExplorer(campx+lOffsetExplo[i][0], campy+lOffsetExplo[i][1], i, 8)


func _on_ButtonC2_pressed():
	var connectMessage="C2"
	print("bouton c1 pressé")
	global.mplayer.send_bytes(connectMessage.to_ascii())
	var i = 2
	if global.playersPresent[i] == 0:
		print("création d'un nouveau explorateur")
		lExplos[i]=createExplorer(campx+lOffsetExplo[i][0], campy+lOffsetExplo[i][1], i, 8)


func _on_ButtonC3_pressed():
	var connectMessage="C3"
	print("bouton c1 pressé")
	global.mplayer.send_bytes(connectMessage.to_ascii())
	var i = 3
	if global.playersPresent[i] == 0:
		print("création d'un nouveau explorateur")
		lExplos[i]=createExplorer(campx+lOffsetExplo[i][0], campy+lOffsetExplo[i][1], i, 8)
