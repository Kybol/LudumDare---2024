extends Node2D

signal ingredient_selected

onready var _player: Node2D = $Player

onready var _parchments: Array = $BackGround.get_children()

# Cauldrons Zone
onready var _cauldrons: Array = $CauldronZone/Cauldrons.get_children()

# Ingredients Zone
onready var _ingredients: Array = $IngredientsZone/Ingredients.get_children()
onready var _player_ingredient_position: Position2D = $IngredientsZone/PlayerIngredientPosition

#Portal
onready var _portal: Node2D = $Portal

onready var _progression_timer: Timer = $ProgressionTimer

var _selected_ingredient: int = -1
var _selected_cauldron: int = -1

var _mouse_is_on_floor: bool 

var _progression_time: float = 30.0
var _min_time: float = Globals.starting_min_time
var _max_time: float = Globals.starting_max_time


func _ready():
	print(Globals.life)
	for ingredient in _ingredients:
		ingredient.connect("selected", self, "on_ingredient_selected")
	
	for cauldron in _cauldrons:
		cauldron.connect("selected", self, "on_cauldron_selected")

	Globals.t = _portal.connect("selected", self, "on_portal_selected")
	
	_progression_timer.start(_progression_time)


func on_ingredient_selected(ingredient_num: int) -> void:
	_selected_ingredient = ingredient_num
	emit_signal("ingredient_selected")


func on_cauldron_selected(cauldron_num: int) -> void:
	_selected_cauldron = cauldron_num
	if _selected_cauldron != -1:
		_player.change_click_position(_cauldrons[_selected_cauldron].player_position.global_position)


func on_portal_selected(_num: int) -> void:
	_player.change_click_position(_portal.player_position.global_position)	


func _on_Player_started_moving():
	if not _mouse_is_on_floor: 
		_player.stop_moving()

	yield(self, "ingredient_selected")

	if _selected_ingredient != -1:
		_player.change_click_position(_player_ingredient_position.global_position)
	

func _on_Floor_mouse_entered():
	_mouse_is_on_floor = true


func _on_Floor_mouse_exited():
	_mouse_is_on_floor = false


func _on_ProgressionTimer_timeout():
	change_parchments_timing(2.0)


func change_parchments_timing(time_to_remove: float) -> void:
	_min_time = _min_time - time_to_remove
	_max_time = _max_time - time_to_remove
	for parchment in _parchments:
		parchment.change_timing(_min_time, _max_time)
		
	_progression_timer.start(_progression_time)


func is_near(position1: Vector2, position2: Vector2, tolerance: float) -> bool:
	return position1.distance_to(position2) <= tolerance


func player_in_front_of_interactable() -> bool:
	var tolerance: float = 3.0
	var in_front_cauldron: bool = is_near(Globals.player.global_position, _cauldrons[0].player_position.global_position, tolerance)
	var in_front_portal: bool = is_near(Globals.player.global_position, _portal.player_position.global_position, tolerance)
	var in_front_ingredients: bool = is_near(Globals.player.global_position, _player_ingredient_position.global_position, tolerance)
	
	print("in_front_cauldron : ", in_front_cauldron)
	print("in_front_portal : ", in_front_portal)
	print("in_front_ingredients : ", in_front_ingredients)
	
	print(in_front_cauldron or in_front_portal or in_front_ingredients)
	
	return in_front_cauldron or in_front_portal or in_front_ingredients


func _on_Player_target_reached():
	if not player_in_front_of_interactable():
		Globals.player.can_interact = false
	else:
		Globals.player.can_interact = true
