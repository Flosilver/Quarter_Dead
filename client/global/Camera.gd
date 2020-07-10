extends Camera

var nodeIS
var coef=15.0

var gameNode = global.controlGameNode

var pressed=[0,0,0,0,0,
	0,0,0,0,0,
	0,0,0,0,0,
	0,0,0,0,0,
	]

# Called when the node enters the scene tree for the first time.
func _ready():
	nodeIS=get_tree().get_root().get_node("ControlGame").get_node("Spatial").get_node("InfoScreen")
	
	print ("InfoScreen",nodeIS)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.get_connected_joypads().size() > 0:
		# joystick de gauche
		var xAxis = Input.get_joy_axis(0,JOY_AXIS_0)	# axe horizontal
		var zAxis = Input.get_joy_axis(0,JOY_AXIS_1)	# axe vertical
		# joystick de droite
		var xAxis1 = Input.get_joy_axis(0,JOY_AXIS_2)	# axe horizontal
		var zAxis1 = Input.get_joy_axis(0,JOY_AXIS_3)	# axe vertical

		if abs(xAxis)>0.6:
			#print("axis 0 : ", xAxis)
			#translation.x+=delta * xAxis * coef / 2
			rotation.y -= xAxis/abs(xAxis) * PI/2
#		if abs(zAxis)>0.6:
#			#print("axis 1 : ", zAxis)
#			#translation.z+=delta * zAxis * coef / 2

#		if abs(xAxis1)>0.6:
#			#print("axis 2 : ", xAxis1)
#			rotation.y -= delta * xAxis1 * coef/2
#			#nodeDialog.hide()
		if abs(zAxis1) > 0.6:
			#print("axis 3 : ", zAxis1)
			translation.y-=delta * zAxis1 * coef / 2
		
		if Input.is_joy_button_pressed(0,JOY_BUTTON_1) and pressed[1]==0:
			pressed[1]=1
			print ("B pressed")
			
			#var cam=get_tree().get_root().get_node("ControlGame").get_node("Spatial").get_node("Camera")
			var dir = global.direction
			var joueur = gameNode.lExplos[dir]
			var x = joueur.translation.x
			var y = joueur.translation.z
			 #cam.set_translation(Vector3(x-global.controlGameNode.lOffsetExplo[dir][0],3,y-global.controlGameNode.lOffsetExplo[dir][1]+2))
			translation.x = x - gameNode.lOffsetExplo[dir][0]
			translation.y = 3
			translation.z = y - gameNode.lOffsetExplo[dir][1] + 2
			
		elif !Input.is_joy_button_pressed(0,JOY_BUTTON_1) and pressed[1]==1:
			pressed[1]=0
			print ("B released")
		
#		if Input.is_joy_button_pressed(0,JOY_BUTTON_0) and pressed[0]==0:
#			pressed[0]=1
#			print ("1 pressed")
#
#			var dir=-1
#
#			if Input.is_joy_button_pressed(0,JOY_BUTTON_12):
#				print("12 pressed")
#				dir=0
#			elif Input.is_joy_button_pressed(0,JOY_BUTTON_13):
#				print("13 pressed")
#				dir=2
#			elif Input.is_joy_button_pressed(0,JOY_BUTTON_14):
#				print("14 pressed")
#				dir=3
#			elif Input.is_joy_button_pressed(0,JOY_BUTTON_15):
#				print("15 pressed")
#				dir=1
#
#			print(dir)
#
##			if dir>=0:
##				var joystickMessage="J"+str(dir)+'1'
##				global.mplayer.send_bytes(joystickMessage.to_ascii())
#
#		elif !Input.is_joy_button_pressed(0,JOY_BUTTON_0) and pressed[0]==1:
#			pressed[0]=0
#			print ("1 released")
#
#		if Input.is_joy_button_pressed(0,JOY_BUTTON_1) and pressed[1]==0:
#			pressed[1]=1
#			print ("2 pressed")
#
#			var dir=-1
#
#			if Input.is_joy_button_pressed(0,JOY_BUTTON_12):
#				dir=0
#			elif Input.is_joy_button_pressed(0,JOY_BUTTON_13):
#				dir=2
#			elif Input.is_joy_button_pressed(0,JOY_BUTTON_14):
#				dir=3
#			elif Input.is_joy_button_pressed(0,JOY_BUTTON_15):
#				dir=1
#
#			print(dir)
#
##			if dir>=0:
##				var joystickMessage="J"+str(dir)+'0'
##				global.mplayer.send_bytes(joystickMessage.to_ascii())
#		elif !Input.is_joy_button_pressed(0,JOY_BUTTON_1) and pressed[1]==1:
#			pressed[1]=0
#			print ("2 released")
#
#		if Input.is_joy_button_pressed(0,JOY_BUTTON_2) and pressed[2]==0:
#			pressed[2]=1
#			print ("3 pressed")
#		elif !Input.is_joy_button_pressed(0,JOY_BUTTON_2) and pressed[2]==1:
#			pressed[2]=0
#			print ("3 released")
#
#		if Input.is_joy_button_pressed(0,JOY_BUTTON_3) and pressed[3]==0:
#			pressed[3]=1
#			print ("4 pressed")
#		elif !Input.is_joy_button_pressed(0,JOY_BUTTON_3) and pressed[3]==1:
#			pressed[3]=0
#			print ("4 released")
#
#		if Input.is_joy_button_pressed(0,JOY_BUTTON_4) and pressed[4]==0:
#			pressed[4]=1
#			print ("5 pressed")
#		elif !Input.is_joy_button_pressed(0,JOY_BUTTON_4) and pressed[4]==1:
#			pressed[4]=0
#			print ("5 released")
#
#		if Input.is_joy_button_pressed(0,JOY_BUTTON_5) and pressed[5]==0:
#			pressed[5]=1
#			print ("6 pressed")
#		elif !Input.is_joy_button_pressed(0,JOY_BUTTON_5) and pressed[5]==1:
#			pressed[5]=0
#			print ("6 released")
#
#		if Input.is_joy_button_pressed(0,JOY_BUTTON_6) and pressed[6]==0:
#			pressed[6]=1
#			print ("7 pressed")
#		elif !Input.is_joy_button_pressed(0,JOY_BUTTON_6) and pressed[6]==1:
#			pressed[6]=0
#			print ("7 released")
#
#		if Input.is_joy_button_pressed(0,JOY_BUTTON_7) and pressed[7]==0:
#			pressed[7]=1
#			print ("8 pressed")
#		elif !Input.is_joy_button_pressed(0,JOY_BUTTON_7) and pressed[7]==1:
#			pressed[7]=0
#			print ("8 released")
#
#		if Input.is_joy_button_pressed(0,JOY_BUTTON_8) and pressed[8]==0:
#			pressed[8]=1
#			print ("9 pressed")
#		elif !Input.is_joy_button_pressed(0,JOY_BUTTON_8) and pressed[8]==1:
#			pressed[8]=0
#			print ("9 released")
#
#		if Input.is_joy_button_pressed(0,JOY_BUTTON_9) and pressed[9]==0:
#			pressed[9]=1
#			print ("10 pressed")
#		elif !Input.is_joy_button_pressed(0,JOY_BUTTON_9) and pressed[9]==1:
#			pressed[9]=0
#			print ("10 released")
#
#		if Input.is_joy_button_pressed(0,JOY_BUTTON_10) and pressed[10]==0:
#			pressed[10]=1
#			print ("11 pressed")
#		elif !Input.is_joy_button_pressed(0,JOY_BUTTON_10) and pressed[10]==1:
#			pressed[10]=0
#			print ("11 released")
#
#		if Input.is_joy_button_pressed(0,JOY_BUTTON_11) and pressed[11]==0:
#			pressed[11]=1
#			print ("11.2 pressed")
#		elif !Input.is_joy_button_pressed(0,JOY_BUTTON_11) and pressed[11]==1:
#			pressed[11]=0
#			print ("11.2 released")

#       pass
