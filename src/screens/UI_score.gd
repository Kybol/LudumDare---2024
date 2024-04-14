extends CanvasLayer


var _actual_score = Globals.score

# Called when the node enters the scene tree for the first time.
func _ready():
	print("ui ready")	
	Globals.connect("succeeded",  self, "_update_score")

func _update_score():
	_actual_score = 5
	print(_actual_score)
