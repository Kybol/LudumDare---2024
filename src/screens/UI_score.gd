extends CanvasLayer

onready var _current_label = $VBoxContainer/HBoxContainer/Score

var _current_score: int = 0
var _current_life = Globals.life
var _death_scene: String = "res://src/screens/death.tscn"
onready var ame1 = $HBoxContainer/ame1
onready var ame2 = $HBoxContainer/ame2
onready var ame3 = $HBoxContainer/ame3

onready var _ames: Array = [ame1, ame2, ame3]

func _ready():
	Globals.connect("success", self, "_update_score")
	Globals.connect("fail", self, "_update_life")
	Globals.connect("parchment_died", self, "_update_life")

func _update_score(_num: int):
	_current_score += 5
	_current_label.text= str(_current_score)
	
func _update_life():
	if _current_life >=4:
		return
	var index = _current_life - 1
	print(index)
	_ames[index].modulate.a = 0.0
	_current_life -= 1
	print(_current_life)
	
	if _current_life < 1:
			Globals.t = get_tree().change_scene(_death_scene)

