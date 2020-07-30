extends Spatial


signal doors_mooved

var doors = [
	#North
	$Piece/PortesNord,
	#East
	$Piece/PortesEst,
	#South
	$Piece/PortesSud,
	#West
	$Piece/PortesOuest,
]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func open_door(dir):
	match dir:
		0:
			$Piece/PortesNord.open_doors()
		1:
			$Piece/PortesEst.open_doors()
		2:
			$Piece/PortesSud.open_doors()
		3:
			$Piece/PortesOuest.open_doors()

func ban_door(dir):
	print("ban_door(dir): TODO")

func open_glass():
	for portes in $Piece.get_children():
		portes.open_glass()

func close_glass():
	for portes in $Piece.get_children():
		portes.close_glass()
