extends CanvasLayer

onready var _current_label = $VBoxContainer/HBoxContainer/Score

var _current_score: int = 0

func _ready():
	print("ui")
	Globals.connect("success", self, "_update_score")

func _update_score():
	_current_score += 5
	_current_label.text= str(_current_score)
