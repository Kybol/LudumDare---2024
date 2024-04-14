extends Node2D

onready var _icons: Array = $ParchmentSprite.get_children()
onready var _time_bar: Line2D = $TimerBar
onready var _reset_timer: Timer = $ResetTimer

var _ingredient_1: int
var _ingredient_2: int
var _ingredient_3: int

func _ready() -> void:
	randomize()
	set_ingredients()
	Globals.connect("success", self, "on_success")


func set_ingredients() -> void:
	_ingredient_1 = rand_range(0, Globals.ingredient_num - 1)
	_ingredient_2 = rand_range(0, Globals.ingredient_num - 1)
	_ingredient_3 = rand_range(0, Globals.ingredient_num - 1)
	
	Globals.recipie = [_ingredient_1, _ingredient_2, _ingredient_3]
	
	var texture_1 = Globals.ingredients_dictionary[_ingredient_1]
	var texture_2 = Globals.ingredients_dictionary[_ingredient_2]
	var texture_3 = Globals.ingredients_dictionary[_ingredient_3]
	
	var textures: Array = [texture_1, texture_2, texture_3]
	
	for i in _icons.size():
		var texture = load(textures[i])
		_icons[i].texture = texture
	
	_time_bar.reset_bar()
	_reset_timer.stop()


func reset_parchment() -> void:
	_ingredient_1 = -1
	_ingredient_2 = -1
	_ingredient_3 = -1
	
	Globals.t = Globals.recipie.empty()
	
	for sprite in _icons:
		sprite.texture = null
	
	_time_bar.stop_bar()
	_reset_timer.start(rand_range(1.0, 2.0))


func on_success() -> void:
	reset_parchment()


func _on_TimerBar_time_to_die():
	Globals.emit_signal("parchment_died")
	reset_parchment()


func _on_ResetTimer_timeout():
	set_ingredients()
