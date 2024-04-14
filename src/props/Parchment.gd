extends Node2D

#var min_time = 1.0
#var max_time = 2.0

onready var _ingredient_1_placeholder: Label = $ColorRect/Label
onready var _ingredient_2_placeholder: Label = $ColorRect/Label2
onready var _ingredient_3_placeholder: Label = $ColorRect/Label3
onready var _time_bar: Line2D = $TimerBar

var _ingredient_1: int
var _ingredient_2: int
var _ingredient_3: int

func _ready() -> void:
	randomize()
	set_ingredients()


func set_ingredients() -> void:
	_ingredient_1 = rand_range(0, Globals.ingredient_num - 1)
	_ingredient_2 = rand_range(0, Globals.ingredient_num - 1)
	_ingredient_3 = rand_range(0, Globals.ingredient_num - 1)
	
	Globals.recipie = [_ingredient_1, _ingredient_2, _ingredient_3]
	
	_ingredient_1_placeholder.text = Globals.ingredients_dictionary[_ingredient_1]
	_ingredient_2_placeholder.text = Globals.ingredients_dictionary[_ingredient_2]
	_ingredient_3_placeholder.text = Globals.ingredients_dictionary[_ingredient_3]
	
	_time_bar.reset_bar()


func reset_parchment() -> void:
	_ingredient_1 = -1
	_ingredient_2 = -1
	_ingredient_3 = -1
	
	Globals.t = Globals.recipie.empty()
	
	_ingredient_1_placeholder.text = ""
	_ingredient_2_placeholder.text = ""
	_ingredient_3_placeholder.text = ""


func _on_TimerBar_time_to_die():
	reset_parchment()
