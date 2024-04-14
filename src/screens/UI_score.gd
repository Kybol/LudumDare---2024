extends CanvasLayer

onready var _current_label = $VBoxContainer/HBoxContainer/Score

var _current_score: int = 0
var _current_life = Globals.life
var _death_scene: String = "res://src/screens/death.tscn"

func _ready():
	Globals.connect("success", self, "_update_score")
	Globals.connect("fail", self, "_update_life")
	Globals.connect("parchment_died", self, "_update_life")

func _update_score(_num: int):
	_current_score += 5
	_current_label.text= str(_current_score)
	
func _update_life():
	_current_life -= 1
	if _current_life < 1:
			Globals.t = get_tree().change_scene(_death_scene)
