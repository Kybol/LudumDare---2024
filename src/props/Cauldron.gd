extends "res://src/props/Hoverable.gd"

const MAX_NUM_INGREDIENT = 3

onready var player_position: Position2D = $PlayerPosition

onready var _cooking_timer: Timer = $CookingTimer
onready var _dots: Node2D = $Dots
onready var _dots_array: Array = $Dots.get_children()
onready var _soup: Sprite = $Visuals/ChaudronSoupe
onready var _fire: Sprite = $Visuals/ChaudronFlammes
onready var _bubbles: Particles2D = $Visuals/Bubbles

var _ingredient_count: int = 0
var _is_on_fire: bool = 0
var _soup_is_waiting: bool = false
var _soup_scene: PackedScene = preload("res://src/assets/Props/Soup.tscn")

var _ingredients_list: Array = []


func _ready() -> void:
	._ready()
	
	_soup_is_waiting = false
	
	remove_dots()
	remove_soup()
	set_fire_off()


func _on_Cauldron_selected(_num) -> void:
	if Globals.player.has_soup(): return
	
	yield(Globals.player, "target_reached")
	
	if not Globals.player.can_interact: return
	
	if _soup_is_waiting:
		take_soup()
	else:
		put_ingredient_in()

	put_ingredient_in()
	
		

func put_ingredient_in() -> void:
	if not Globals.player.hands_are_full() or _is_on_fire: return
	
	var ingredient = Globals.player.remove_ingredient_from_hands()
	_ingredient_count += 1
	
	print(ingredient)
	print(ingredient.ingredient_type)
	
	_ingredients_list.append(ingredient)
	
	if _ingredient_count == 1:
		put_soup()
	
	_dots_array[_ingredient_count - 1].modulate.a = 1.0
	
	if _ingredient_count == MAX_NUM_INGREDIENT:
		_soup_is_waiting = true
		set_fire_on()


func take_soup() -> void:
	remove_soup()
	_soup_is_waiting = false
	var soup = _soup_scene.instance()
	soup.set_ingredient_list(_ingredients_list)
	_ingredients_list = []
	Globals.player.put_ingredient_in_hands(soup, true)


func set_fire_on():
	is_idle = false
	_is_on_fire = true
	_fire.modulate.a = 1.0
	_cooking_timer.start(rand_range(3.0, 5.0))


func set_fire_off():
	is_idle = true	
	_is_on_fire = false
	_fire.modulate.a = 0.0
	_cooking_timer.stop()
	_ingredient_count = 0
	remove_dots()


func put_soup() -> void:
	_soup.modulate.a = 1.0	
	_bubbles.emitting = true


func remove_soup() -> void:
	_soup_is_waiting = false
	_soup.modulate.a = 0.0	
	_bubbles.emitting = false


func remove_dots() -> void:
	for dot in _dots_array:
		dot.modulate.a = 0.0


func _on_CookingTimer_timeout():
	set_fire_off()
