extends Control

var connexion_node = global.controlConnexionNode

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
	"res://tiles/Game/Texture/texturePersonnageAcrobate.png",
	#01
	"res://tiles/Game/Texture/texturePersonnageCordonier.png", 
	#02
	"res://tiles/Game/Texture/texturePersonnage.png", 
	#03
	"res://tiles/Game/Texture/texturePersonnageMedecin.png", 
	#04
	"res://tiles/Game/Texture/texturePersonnageHommeChat.png", 
	#05
	"res://tiles/Game/Texture/texturePersonnageHommeChat.png",
	#06
	"res://tiles/Game/Texture/textureRobot.png",
	#07
	"res://tiles/Game/Texture/texturePersonnageTank.png",
	#08 : chemin de la texture pour le modèle temporaire
	"res://tiles/Game/Texture/texturePersonnage.png"
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

var lOffsetExplo=[
	[-0.5,0.5],
	[0.5,0.5],
	[0.5,-0.5],
	[-0.5,-0.5],
]

# liste contenant les pointeurs vers les 4 mesh des joueurs
var lExplos=[null,null,null,null]
var lPosExplos = [null, null, null, null]
#var campx
#var campy
var pressed=[0,0,0,0,0,
	0,0,0,0,0,
	0,0,0,0,0,
	0,0,0,0,0,
	]

var maze
const roomOff = 7
var door_dir = {}
var lTargets = [null,null,null,null]


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for i in range(global.NB_J):
		if lTargets[i] != null and lExplos[i] != null:
			var dep = (lTargets[i] - lExplos[i].translation)
			if abs(dep.x) >= 0.1:
#				print("deplacement en x")
				lExplos[i].translation.x += 0.1 * (abs(dep.x)/dep.x)
			else:
				lExplos[i].translation.x = lTargets[i].x
#			if dep.y != 0:
#				lExplos[i].translation.y += (dep.y / roomOff) / 10
			if abs(dep.z) >= 0.1:
#				print("deplacement en z")
				lExplos[i].translation.z += 0.1 * (abs(dep.z)/dep.z)
			else:
				lExplos[i].translation.z = lTargets[i].z


func _networkMessage(mess):
	print ("_networkMessage=",mess)
	var dir
	match (global.etat):
		0:	# CONNEXION des joueurs
			match (mess[0]):
				'c':	# connexion des joueurs
					var cnx
					for i in range(global.NB_J):
						cnx = int(mess[i+1])
						if global.playersPresent[i]==0 and cnx==1:
							global.playersPresent[i]=1
							connexion_node.add_new_player(i)
							# un nouveau joueur s'est connecté et il est créé dans la scnene de connexion et celle du jeu
						if global.playersPresent[i]==1 and cnx==0:
							global.playersPresent[i]=0
							connexion_node.remove_new_player(i)
							# un nouveau joueur s'est déconnecté et il est supprimé dans la scnene de connexion et celle du jeu
				
				'j':	# infos sur le jeux
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
				
				'g':	# generation d'un etage
					var idr = 2
					# étage a construire
					var etage = int(mess[1])
					for i in range(global.map_size):
						for j in range(global.map_size):
							maze[etage][i][j] = int(mess[idr])
							#print(maze[etage][i][j])
							idr += 1
					if etage == global.level:
						buildMaze(etage)
				
				'p':	# placement des pions
					var y = int(mess[1])
					var x = int(mess[2])
		#			x = 0
		#			y = 0
					for i in range(global.NB_J):
						lExplos[i].set_translation(Vector3((x*roomOff)+lOffsetExplo[i][0],0,(y*roomOff)+lOffsetExplo[i][1]))
					$Cam.set_translation(Vector3(x*roomOff,1.6,(y*roomOff)))
				
				'r': # distribution des rôles
					var xtemp
					var ytemp
					var ztemp
					for i in range(global.NB_J):
						xtemp = lExplos[i].translation.x
						ytemp = lExplos[i].translation.y
						ztemp = lExplos[i].translation.z
						createExplorer(xtemp,ztemp,i,int(mess[i+1]))
						lPosExplos[i] = Vector3(xtemp, ytemp, ztemp)
						lExplos[i].set_translation(Vector3(xtemp,ytemp,ztemp))
					global.etat = 1
					connexion_node.start_game()
		1:	# etat de jeu
			match mess[0]:
				'o': # ouverture de porte
					if ( mess[1] == 'y' ):
						var who = int(mess[2])
						var wich = int(mess[3])
						var etage = int(mess[4])
						if lExplos[who] != null:
							print("who: ", who, "\twich: ", wich)
							print("player: x=", lExplos[who].translation.z, "\ty=", lExplos[who].translation.x)
							print("fonction: x=", getPlayerX(who), "\ty=", getPlayerY(who))
							maze[global.level][getPlayerX(who)][getPlayerY(who)].open_door(wich)
							match wich:
								0:
									maze[global.level][getPlayerX(who)-1][getPlayerY(who)].open_door((wich+2)%4)
								1:
									maze[global.level][getPlayerX(who)][getPlayerY(who)+1].open_door((wich+2)%4)
								2:
									maze[global.level][getPlayerX(who)+1][getPlayerY(who)].open_door((wich+2)%4)
								3:
									maze[global.level][getPlayerX(who)][getPlayerY(who)-1].open_door((wich+2)%4)
				'e': # deplacement dans une salle
					if mess[1] ==  'y':
						var who = int(mess[2])
						var wich = int(mess[3])
						var deplacement
						match wich:
							0:
								deplacement = Vector3(0,0,-roomOff)
							1:
								deplacement = Vector3(roomOff,0,0)
							2:
								deplacement = Vector3(0,0,roomOff)
							3:
								deplacement = Vector3(-roomOff,0,0)
						if lExplos[who] != null:
#							lExplos[who] += deplacement
							lTargets[who] = lExplos[who].translation + deplacement
							print("target: ", lTargets[who])
		#				lExplos[who].translation.x += deplacement.x
		#				lExplos[who].translation.y += deplacement.y
		#				lExplos[who].translation.z += deplacement.z
						if who == global.direction:
#							var cam = get_tree().get_root().get_node("ControlGame").get_node("Spatial").get_node("Camera")
							var t = lTargets[who]
							t.x -= lOffsetExplo[who][0]
							t.y = 1.6
							t.z -= lOffsetExplo[who][1]
							$Cam.setTarget(t)
				
				'i':	# reception d'infos
					# on sépare la chaine de charactere reçu pour identifier les infos
					var mess_array = mess.rsplit(" ",true)
					# 0: i,	1: dir,	2: etage,	3: hp,	4: nbChauss
					if int(mess_array[1]) == global.direction:
						$Cam/InfoScreen/Etage.set_text(mess_array[2])
						$Cam/InfoScreen/Health.set_text(mess_array[3])
						$Cam/InfoScreen/Chaussure.set_text(mess_array[4])
						global.level = int(mess_array[2])
				
				'l':	# lancé de chaussure
					match mess[1]:
						'y':
							dir = int(mess[2])
							var etage = int(mess[3])
							if etage == global.level:
								var chauss = load("res://Game/ShoeThrow.tscn").instance()
								chauss.rotation.y -= PI/2 * global.vise
								maze[etage][getPlayerX(dir)][getPlayerY(dir)].add_child(chauss)
				
				'v':	# ordre de bouger les portes vitrées
					var etage = int(mess[2])
					if etage == global.level:
						var v_room = Vector2(int(mess[3]), int(mess[4]))
						if mess[1] == 'c':
							maze[etage][v_room.x][v_room.y].close_glass()
						if mess[1] == 'o':
							maze[etage][v_room.x][v_room.y].open_glass()
				 
				't':	# un joueur est tombé dans un piège
					var etage = int(mess[1])
					if etage == global.level:
						var v_room = Vector2(int(mess[2]), int(mess[3]))
						var trap
						var path = "res://Game/Trap&Fatal/Trap" + mess[4] + ".tscn"
						trap = load(path).instance()
						maze[etage][v_room.x][v_room.y].add_child(trap)
						trap.connect("trap_anim_finished", self, "_on_trap_anim_finished", [mess[1], mess[2], mess[3]])
				
				'f':	# un joueur est tombé dans un fatal
					var etage = int(mess[1])
					if etage == global.level:
						var v_room = Vector2(int(mess[2]), int(mess[3]))
						var trap
						var path = "res://Game/Trap&Fatal/Fatal" + mess[4] + ".tscn"
						trap = load(path).instance()
						maze[etage][v_room.x][v_room.y].add_child(trap)
						trap.connect("trap_anim_finished", self, "_on_trap_anim_finished", [mess[1], mess[2], mess[3]])
				
				'm':	# un joueur est mort
					dir = int(mess[1])
					lExplos = null
					if dir == global.direction:
						global.change_scene(global.controlEndNode)
						global.controlEndNode.set_text("Vous etes mort")
					else:
						var info_mess = "Le joueur " + str(dir) + " est mort"
						var node_mess = load("res://Game/Info/Message.tscn").instance()
						node_mess.set_text(info_mess)
						$Cam/InfoScreen.add_child(node_mess)
				
				's':	# un joueur a ressucité
					dir = int(mess[1])
					var info_mess
					var node_mess
					if dir == global.direction:
						info_mess = "Vous ressucitez"
					else:
						info_mess = "Le joueur " + str(dir) + " ressucite"
					node_mess = load("res://Game/Info/Message.tscn").instance()
					node_mess.set_text(info_mess)
					$Cam/InfoScreen.add_child(node_mess)
				
				'w':	# un joueur a gagné
					global.etat = 2
					end_game()
					global.change_scene(global.controlEndNode)
					global.controlEndNode.set_text("VICTOIRE")

func add_player(num):
	print("ajout ingame du joueur: ", num)
	var mi = MeshInstance.new()
	$Players.add_child(mi)
	lExplos[num] = mi

func remove_player(num):
	if lExplos[num] != null:
		$Players.remove_child(lExplos[num])
		lExplos[num] = null;

func createExplorer(x,y,who,role):
	# Create a new tile instance
	var mi=lExplos[who]
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
	lExplos[who] = mi
	# add the newly created instance as a child of the Origine3D Node
#	$Spatial.add_child(mi)
#	return mi

func buildMaze(etage):
	print("construction du terrain")
	for i in range(global.map_size):
		for j in range(global.map_size):
			if maze[etage][i][j] != 5:
				maze[etage][i][j] = load("res://Game/Room/Room.tscn").instance()
			else:
				maze[etage][i][j] = load("res://Game/Room/Goal.tscn").instance()
			maze[etage][i][j].set_translation(Vector3(j*roomOff, 0, i*roomOff))
			if i == 0:
				maze[etage][i][j].ban_door(0)
			if i == global.map_size-1:
				maze[etage][i][j].ban_door(2)
			if j == 0:
				maze[etage][i][j].ban_door(3)
			if j == global.map_size-1:
				maze[etage][i][j].ban_door(1)
			$Maze.add_child(maze[etage][i][j])

func getPlayerX(player):
	var p = lExplos[player]
	var x = (p.translation.z - lOffsetExplo[player][1]) / (roomOff)
	#print("player[",player,"].X = ",x)
	return int(x)

func getPlayerY(player):
	var p = lExplos[player]
	var y = (p.translation.x - lOffsetExplo[player][0]) / (roomOff)
	#print("player[",player,"].Y = ",y)
	return int(y)

func _on_trap_anim_finished(etage, roomX, roomY):
	var releaseMess = 'R' + etage + roomX + roomY #str(global.direction)
	global.mplayer.send_bytes(releaseMess.to_ascii())


func end_game():
	print("the end")
