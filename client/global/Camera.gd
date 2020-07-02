extends Camera

var nodeIS
var coef=15.0

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
		var xAxis = Input.get_joy_axis(0,JOY_AXIS_0)
		var zAxis = Input.get_joy_axis(0,JOY_AXIS_1)
		#print (abs(xAxis), abs(zAxis))
		if abs(xAxis)>0.1:
			translation.z-=delta * xAxis * coef
		if abs(zAxis)>0.1:
			translation.x+=delta * zAxis * coef

		var xAxis1 = Input.get_joy_axis(0,JOY_AXIS_2)
		var zAxis1 = Input.get_joy_axis(0,JOY_AXIS_3)
		if abs(xAxis1)>0.1:
			translation.y+=delta * xAxis1 * coef
			#nodeDialog.hide()
		
		if Input.is_joy_button_pressed(0,JOY_BUTTON_0) and pressed[0]==0:
			pressed[0]=1
			print ("1 pressed")

			var dir=-1
			
			if Input.is_joy_button_pressed(0,JOY_BUTTON_12):
				dir=0
			elif Input.is_joy_button_pressed(0,JOY_BUTTON_13):
				dir=2
			elif Input.is_joy_button_pressed(0,JOY_BUTTON_14):
				dir=3
			elif Input.is_joy_button_pressed(0,JOY_BUTTON_15):
				dir=1
				
			print(dir)
			
			if dir>=0:
				var joystickMessage="J"+str(dir)+'1'
				global.mplayer.send_bytes(joystickMessage.to_ascii())
				
		elif !Input.is_joy_button_pressed(0,JOY_BUTTON_0) and pressed[0]==1:
			pressed[0]=0
			print ("1 released")

		if Input.is_joy_button_pressed(0,JOY_BUTTON_1) and pressed[1]==0:
			pressed[1]=1
			print ("2 pressed")

			var dir=-1
			
			if Input.is_joy_button_pressed(0,JOY_BUTTON_12):
				dir=0
			elif Input.is_joy_button_pressed(0,JOY_BUTTON_13):
				dir=2
			elif Input.is_joy_button_pressed(0,JOY_BUTTON_14):
				dir=3
			elif Input.is_joy_button_pressed(0,JOY_BUTTON_15):
				dir=1

			print(dir)

			if dir>=0:
				var joystickMessage="J"+str(dir)+'0'
				global.mplayer.send_bytes(joystickMessage.to_ascii())
		elif !Input.is_joy_button_pressed(0,JOY_BUTTON_1) and pressed[1]==1:
			pressed[1]=0
			print ("2 released")

#       pass
