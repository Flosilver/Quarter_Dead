extends Spatial


const coef=15.0
const seuil = 0.01

var gameNode = global.controlGameNode

var pressed=[0,0,0,0,0,
	0,0,0,0,0,
	0,0,0,0,0,
	0,0,0,0,0,
	]

var angle = 0.0
var angle_dest = 0.0
var target = null
var mouvR = 0
var mouvT = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pivot()
	move()
	if Input.get_connected_joypads().size() > 0:
		# joystick de gauche
		var xAxis = Input.get_joy_axis(0,JOY_AXIS_0)	# axe horizontal
		var zAxis = Input.get_joy_axis(0,JOY_AXIS_1)	# axe vertical
		# joystick de droite
		var xAxis1 = Input.get_joy_axis(0,JOY_AXIS_2)	# axe horizontal
		var zAxis1 = Input.get_joy_axis(0,JOY_AXIS_3)	# axe vertical
		
		if abs(xAxis)>0.8 and mouvR==0 and mouvT==0:
			mouvR = 1
			angle_dest -= xAxis/abs(xAxis) * PI/2#(int(xAxis/abs(xAxis)) * 90)
			global.vise += int(xAxis/abs(xAxis))
			global.vise = global.vise%4
			if (global.vise < 0 ):
				global.vise += 4
				
#		if abs(xAxis1)>0.6:
##			print("axis 2 : ", xAxis1)
#			translation.x+=delta * xAxis1 * coef / 2
##			nodeDialog.hide()
#		if abs(zAxis1) > 0.6:
##			print("axis 3 : ", zAxis1)
#			translation.z+=delta * zAxis1 * coef / 2
		
		if Input.is_joy_button_pressed(0,JOY_BUTTON_0) and pressed[0]==0 and mouvR+mouvT == 0:
			pressed[0] = 1
			print ("A pressed")
			# bouton pour demaner l'ouverture d'une porte
			var doorMessage = "O" + str(global.direction) + str(global.vise)# + str(global.level)
			global.mplayer.send_bytes(doorMessage.to_ascii())
		if !Input.is_joy_button_pressed(0,JOY_BUTTON_0) and pressed[0]==1:
			pressed[0] = 0
			print ("A released")
		
		if Input.is_joy_button_pressed(0,JOY_BUTTON_1) and pressed[1]==0 and mouvR+mouvT == 0:
			pressed[1]=1
			print ("B pressed")
			# bouton pour demander d'entrée dans une salle
			var entreeMessage = "E" + str(global.direction) + str(global.vise)# + str(global.level)
			global.mplayer.send_bytes(entreeMessage.to_ascii())
		elif !Input.is_joy_button_pressed(0,JOY_BUTTON_1) and pressed[1]==1:
			pressed[1]=0
			print ("B released")
			
		if Input.is_joy_button_pressed(0,JOY_BUTTON_2) and pressed[2]==0:
			pressed[2] = 1
			print("X pressed")
			print("vise: ",global.vise)
		if !Input.is_joy_button_pressed(0,JOY_BUTTON_2) and pressed[2]==1:
			pressed[2] = 0
			print("X released")
		
		if Input.is_joy_button_pressed(0,JOY_BUTTON_6) and pressed[6] == 0:
			pressed[6] = 1
			print("LT pressed")
			if mouvT + mouvR == 0:
				var throwShoeMess = "L" + str(global.direction) + str(global.vise)
				global.mplayer.send_bytes(throwShoeMess.to_ascii())
		if !Input.is_joy_button_pressed(0,JOY_BUTTON_6) and pressed[6] == 1:
			pressed[6] = 0
			print("LT released")
			
#		if Input.is_joy_button_pressed(0,JOY_BUTTON_4) and pressed[4]==0:
##			pressed[4]=1
##			print ("5 pressed")
#			translation.y -= delta * coef / 2
#
#		if Input.is_joy_button_pressed(0,JOY_BUTTON_5) and pressed[5]==0:
##			pressed[5]=1
##			print ("6 pressed")
#			translation.y += delta * coef / 2

func pivot():
	if (abs(angle - angle_dest) > seuil):
#		print("angle:", angle, " angle_dest:", angle_dest)
		var signe = angle_dest - angle
		if (signe > 0):
			rotation.y += seuil * 1.5
		else:
			rotation.y -= seuil * 1.5
		angle = rotation.y#int(rotation.y * 180 / PI)
#		print("angle: ",angle)
	else:
		mouvR = 0

func setTarget(t):
	target = t
	mouvT = 1

func move():
	if target != null and mouvT == 1 and mouvR == 0:
		var d = target - translation
#		print(d.length())
		if d.length() >= 0.01:
#			print("---")
#			print("d.x: ",d.x,"  d.y: ",d.y,"  d.z: ",d.z)
			var d2 = (d.normalized())/10
#			print("d.x: ",d2.x,"  d.y: ",d2.y,"  d.z: ",d2.z)
			translation += d2
		else:
#			print("mouv a 0")
			mouvT = 0
			var inMessage = "I" + str(global.direction)
			global.mplayer.send_bytes(inMessage.to_ascii())


func reboot_cam():
	set_translation(Vector3(0,0,0))
	set_rotation(Vector3(0,0,0))
	angle = 0.0
	angle_dest = 0.0
	target = null
	mouvR = 0
	mouvT = 0
