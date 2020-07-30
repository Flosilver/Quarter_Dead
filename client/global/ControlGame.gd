extends Control

var explorerColor=[Color(255,0,0),Color(0,255,0),Color(0,0,255),Color(255,255,0)]
# chemins vers les différents des objets rooms

#var objRooms=[
#	#00
#	"res://obj/Piece.obj",
#	#01
#	"res://obj/", 
#	#02
#	"res://obj/", 
#	#03
#	"res://obj/", 
#	#04
#	"res://obj/", 
#	#05
#	"res://obj/", 
#]
var objRooms = [
	#00
	"res://obj/Piece.obj",
	#01
	"res://obj/Sortie.obj",
	]
# chemins vers les textures associées aux rooms
var tileRooms=[
	 #00
	"res://tiles/Texture/texturePiece.png",
	#01
	"res://tiles/Texture/textureGoal.png", 
#	#02
#	"res://tiles/Texture/", 
#	#03
#	"res://tiles/Texture/", 
#	#04
#	"res://tiles/Texture/", 
#	#05
#	"res://tiles/Texture/", 
]
# textures des rooms
var txRooms=[
	#00
	null,
	#01
	null, 
#	#02
#	null, 
#	#03
#	null, 
#	#04
#	null, 
#	#05
#	null, 
]
var objDoors=[
	#00
	"res://obj/PorteGauche.obj",
	#01
	"res://obj/PorteDroite.obj", 
	#02
	"res://obj/PorteVerre.obj",
	#03
	"res://obj/Vitre.obj"
]
var tileDoors=[
	#00
	"res://tiles/Texture/texturePorteGauche.png",
	#01
	"res://tiles/Texture/texturePorteDroite.png", 
	#02
	"res://tiles/Texture/texturePorteVerre.png",
	#03
	"res://tiles/Texture/",
	#04
	"res://tiles/Texture/texturePorteGaucheRed.png"
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
	"res://obj/Personnage.obj",
	#01
	"res://obj/Personnage.obj", 
	#02
	"res://obj/Personnage.obj", 
	#03
	"res://obj/Personnage.obj", 
	#04
	"res://obj/PersonnageHommeChat.obj", 
	#05
	"res://obj/PersonnageHommeChat.obj",
	#06
	"res://obj/Robot.obj",
	#07
	"res://obj/Personnage.obj",
	#08 : obj du modèle temporaire pour la connexion
	"res://obj/Personnage.obj"
]
var tileExplo=[
	#00
	"res://tiles/Texture/texturePersonnageAcrobate.png",
	#01
	"res://tiles/Texture/texturePersonnageCordonier.png", 
	#02
	"res://tiles/Texture/texturePersonnage.png", 
	#03
	"res://tiles/Texture/texturePersonnageMedecin.png", 
	#04
	"res://tiles/Texture/texturePersonnageHommeChat.png", 
	#05
	"res://tiles/Texture/texturePersonnageHommeChat.png",
	#06
	"res://tiles/Texture/textureRobot.png",
	#07
	"res://tiles/Texture/texturePersonnageTank.png",
	#08 : chemin de la texture pour le modèle temporaire
	"res://tiles/Texture/texturePersonnage.png"
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
var door_dir = {}
var lTargets = [null,null,null,null]

# Called when the node enters the scene tree for the first time.
func _ready():

	campx=-5
	campy=-5
	var i = global.direction
	lExplos[i]=createExplorer(campx+lOffsetExplo[i][0], campy+lOffsetExplo[i][1],i,8)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	anim_doors()

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
#			var pp = global.playersPresent
#			if (pp[0] + pp[1] + pp[2] + pp[3] == 4):
#				var root=get_tree().get_root()
#				var myself=root.get_child(1)
#				print ("info ",root,myself)

		'j':	# récupère les variable des dimensions du jeu
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
				lExplos[i] = createExplorer(xtemp,ztemp,i,int(mess[i+1]))
				lExplos[i].set_translation(Vector3(xtemp,ytemp,ztemp))
		
		'o': # ouverture de porte
			if ( mess[1] == 'y' ):
				var who = int(mess[2])
				var wich = int(mess[3])
				openDoor(global.level, getPlayerX(who), getPlayerY(who), wich)
				match wich:
					0:
						openDoor(global.level, getPlayerX(who)-1, getPlayerY(who), (wich+2)%4)
					1:
						openDoor(global.level, getPlayerX(who), getPlayerY(who)+1, (wich+2)%4)
					2:
						openDoor(global.level, getPlayerX(who)+1, getPlayerY(who), (wich+2)%4)
					3:
						openDoor(global.level, getPlayerX(who), getPlayerY(who)-1, (wich+2)%4)
		
		'e': # deplacement dans une salle
			if mess[1] ==  'y':
				var who = int(mess[2])
				var wich = int(mess[3])
				var deplacement
				match wich:
					0:
						deplacement = Vector3(0,0,-2*roomOff)
					1:
						deplacement = Vector3(2*roomOff,0,0)
					2:
						deplacement = Vector3(0,0,2*roomOff)
					3:
						deplacement = Vector3(-2*roomOff,0,0)
				lExplos[who].translation += deplacement
				lTargets[who] = lExplos[who].translation
				print("target: ", lTargets[who])
#				lExplos[who].translation.x += deplacement.x
#				lExplos[who].translation.y += deplacement.y
#				lExplos[who].translation.z += deplacement.z
				if who == global.direction:
					var cam = get_tree().get_root().get_node("ControlGame").get_node("Spatial").get_node("Camera")
					var t = lTargets[who]
					t.x -= lOffsetExplo[who][0]
					t.y = 2
					t.z -= lOffsetExplo[who][1]
					cam.setTarget(t)
		
		'i':	# reception d'infos
			var mess_array = mess.rsplit(" ",true)
			#0: i,	1: dir,	2: etage,	3: hp,	4: nbChauss
			if int(mess_array[1]) == global.direction:
				$Spatial/InfoScreen/etage.set_text(mess_array[2])
				$Spatial/InfoScreen/health.set_text(mess_array[3])
				$Spatial/InfoScreen/nb_chauss.set_text(mess_array[4])
				global.level = int(mess_array[2])
		
		'v':	# demande de fermer ou ouvrir les vitres
			if mess[1] == 'c':
				print("fermeture des vitres")
				CloseGlass(int(mess[2]), int(mess[3]), int(mess[4]))
			
			if mess[1] == 'o':
				print("ouverture des vitres")
				OpenGlass(int(mess[2]), int(mess[3]), int(mess[4]))

func createRoom(x,y,room_num):
	# Create a new room instance
	if room_num == 5:
		room_num = 1
	else:
		room_num = 0
	var mi=MeshInstance.new()
	# and translate it to its final position
	mi.set_translation(Vector3(y,0,x))
	# load the room mesh
	var meshObj=load(objRooms[room_num])#objRooms[room_num])
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
		vpos = Vector3(0,2,0)		# vecteur de position de la porte vitrée
		# adaptation des position
		match i:
			0:
				ppos.z = -distP
				vpos.z = -distV
			1:
				ppos.x = distP
				vpos.x = distV
			2:
				ppos.z = distP
				vpos.z = distV
			3:
				ppos.x = -distP
				vpos.x = -distV
		for j in range(4):
			# création de la Mesh
			portes[j] = MeshInstance.new()
			# positionnement de la Mesh
			if (j<2):
				portes[j].set_translation(ppos)
			else:
				portes[j].set_translation(vpos)
			portes[j].set_rotation(Vector3(0,-PI/2 - i*PI/2,0))
			# load du modèle
			portes[j].mesh = load(objDoors[j])
			#instanciation de la texture
			if j == 3:
				tx_portes[j] = load("res://tiles/Material/Vitre.material")
			else:
				tx_portes[j] = SpatialMaterial.new()
			# assignation de la texture
			portes[j].set_surface_material(0,tx_portes[j])
#			portes[j].material = load("res://tiles/Material/Vitre.material")
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

func getPlayerX(player):
	var p = lExplos[player]
	var x = (p.translation.z - lOffsetExplo[player][1]) / (2*roomOff)
	#print("player[",player,"].X = ",x)
	return x

func getPlayerY(player):
	var p = lExplos[player]
	var y = (p.translation.x - lOffsetExplo[player][0]) / (2*roomOff)
	#print("player[",player,"].Y = ",y)
	return y

func openDoor( etage, roomX, roomY, door):
#	print("x: ", roomX, " y: ", roomY)
	var room = maze[etage][roomX][roomY];
	var lDoor = room.get_child(4*door)
	var rDoor = room.get_child(4*door+1)
	var transL = lDoor.translation
	var transR = rDoor.translation
	match door:
		0:
#			print("porte 0")
			if (!door_dir.has_all([lDoor,rDoor])):
#				print("les portes étaient fermées")
				door_dir[lDoor] = Vector3(transL.x-1,transL.y,transL.z)
				door_dir[rDoor] = Vector3(transR.x+1,transR.y,transR.z)
#				print("ouverture")
		1:
#			print("porte 1")
			if (!door_dir.has_all([lDoor,rDoor])):
#				print("les portes étaient fermées")
				door_dir[lDoor] = Vector3(transL.x,transL.y,transL.z-1)
				door_dir[rDoor] = Vector3(transR.x,transR.y,transR.z+1)
#				print("ouverture")
		2:
#			print("porte 2")
			if (!door_dir.has_all([lDoor,rDoor])):
#				print("les portes étaient fermées")
				door_dir[lDoor] = Vector3(transL.x+1,transL.y,transL.z)
				door_dir[rDoor] = Vector3(transR.x-1,transR.y,transR.z)
#				print("ouverture")
		3:
#			print("porte 3")
			if (!door_dir.has_all([lDoor,rDoor])):
#				print("les portes étaient fermées")
				door_dir[lDoor] = Vector3(transL.x,transL.y,transL.z+1)
				door_dir[rDoor] = Vector3(transR.x,transR.y,transR.z-1)
#				print("ouverture")

func anim_doors():
	if door_dir.size() != 0:
		var pos
		var target
		for mesh in door_dir:
			pos = mesh.translation
			target = door_dir[mesh]
			if pos != target:
#				print("mesh: ", mesh)
#				print("pos: ", pos, "  target: ", target)
				if abs(pos.x - target.x) > 0.02 :
#					print("deplacement selon x")
#					print("pos.x: ", pos.x, "  target.x: ", target.x)
					mesh.translation.x = pos.x + abs(target.x-pos.x)/(target.x-pos.x) * 0.02
#					pos.x += abs(target.x-pos.x)/(target.x-pos.x) * 0.05
				if abs(pos.z - target.z) > 0.02 :
#					print("deplacement selon z")
#					print("pos.z: ", pos.z, "  target.z: ", target.z)
					mesh.translation.z = pos.z + abs(target.z-pos.z)/(target.z-pos.z) * 0.02
#					pos.z += abs(target.z-pos.z)/(target.z-pos.z) * 0.05

func CloseGlass(etage, glassX, glassY):
	var room = maze[etage][glassX][glassY];
	var glass
	var vitre
	for i in range(4):
		glass = room.get_child(i*4+2)
		vitre = room.get_child(i*4+3)
		glass.translation.y = 0
		vitre.translation.y = 0

func OpenGlass(etage, glassX, glassY):
	var room = maze[etage][glassX][glassY];
	var glass
	var vitre
	for i in range(4):
		glass = room.get_child(i*4+2)
		vitre = room.get_child(i*4+3)
		glass.translation.y = 2
		vitre.translation.y = 2

func _on_ButtonMenu_pressed():
	var root=get_tree().get_root()
	var myself=root.get_child(1)
#	print (root,myself)
	root.remove_child(myself)
	root.add_child(global.controlMenuNode)


func _on_ButtonC1_pressed():
	var pp = global.playersPresent
	if !(pp[0] + pp[1] + pp[2] + pp[3] == 4):
		var connectMessage="C1"
#		print("bouton c1 pressé")
		global.mplayer.send_bytes(connectMessage.to_ascii())
		var i = 1
		if global.playersPresent[i] == 0:
			global.playersPresent[i] = 1
#			print("création d'un nouveau explorateur")
			lExplos[i]=createExplorer(campx+lOffsetExplo[i][0], campy+lOffsetExplo[i][1], i, 8)


func _on_ButtonC2_pressed():
	var pp = global.playersPresent
	if !(pp[0] + pp[1] + pp[2] + pp[3] == 4):
		var connectMessage="C2"
#		print("bouton c2 pressé")
		global.mplayer.send_bytes(connectMessage.to_ascii())
		var i = 2
		if global.playersPresent[i] == 0:
			global.playersPresent[i] = 1
#			print("création d'un nouveau explorateur")
			lExplos[i]=createExplorer(campx+lOffsetExplo[i][0], campy+lOffsetExplo[i][1], i, 8)


func _on_ButtonC3_pressed():
	var pp = global.playersPresent
	if !(pp[0] + pp[1] + pp[2] + pp[3] == 4):
		var connectMessage="C3"
#		print("bouton c3 pressé")
		global.mplayer.send_bytes(connectMessage.to_ascii())
		var i = 3
		if global.playersPresent[i] == 0:
			global.playersPresent[i] = 1
#			print("création d'un nouveau explorateur")
			lExplos[i]=createExplorer(campx+lOffsetExplo[i][0], campy+lOffsetExplo[i][1], i, 8)
