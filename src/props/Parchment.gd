extends Node2D

export (int) var number: int
export (int) var parchement: int

onready var _icons: Array = $ParchmentSprite.get_children()
onready var _time_bar: Line2D = $TimerBar
onready var _reset_timer: Timer = $ResetTimer
onready var _parchment: Sprite = $Parchment1
onready var _parchment_2: Sprite = $Parchment2
onready var _parchment_3: Sprite = $Parchment3

var _ingredient_1: int
var _ingredient_2: int
var _ingredient_3: int

func _ready() -> void:
	randomize()
	
	match parchement:
		1:
			_parchment.visible = true
			_parchment_2.visible = false
			_parchment_3.visible = false
		2:
			_parchment.visible = false
			_parchment_2.visible = true
			_parchment_3.visible = false
		3:
			_parchment.visible = false
			_parchment_2.visible = false
			_parchment_3.visible = true
	
	set_ingredients()
	Globals.t = Globals.connect("success", self, "on_success")


func set_ingredients() -> void:
	_ingredient_1 = rand_range(0, Globals.ingredient_num)
	_ingredient_2 = rand_range(0, Globals.ingredient_num)
	_ingredient_3 = rand_range(0, Globals.ingredient_num)
	
	match number:
		1:
			Globals.recipie = [_ingredient_1, _ingredient_2, _ingredient_3]
		2:
			Globals.recipie_2 = [_ingredient_1, _ingredient_2, _ingredient_3]
		3:
			Globals.recipie_3 = [_ingredient_1, _ingredient_2, _ingredient_3]
	
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


func on_success(num: int) -> void:
	if num != number: return
	reset_parchment()


func change_timing(min_time, max_time) -> void:
	if min_time <= 2.0: return
	
	_time_bar.min_time = min_time
	_time_bar.max_time = max_time


func _on_TimerBar_time_to_die():
	Globals.emit_signal("parchment_died")
	reset_parchment()


func _on_ResetTimer_timeout():
	set_ingredients()
