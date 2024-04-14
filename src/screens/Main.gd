extends Node2D

signal ingredient_selected

onready var _player: Node2D = $Player

# Cauldrons Zone
onready var _cauldrons: Array = $CauldronZone/Cauldrons.get_children()

# Ingredients Zone
onready var _ingredients: Array = $IngredientsZone/Ingredients.get_children()
onready var _player_ingredient_position: Position2D = $IngredientsZone/PlayerIngredientPosition

#Portal
onready var _portal: Node2D = $Portal

var _selected_ingredient: int = -1
var _selected_cauldron: int = -1

var _mouse_is_on_floor: bool 


func _ready():
	for ingredient in _ingredients:
		ingredient.connect("selected", self, "on_ingredient_selected")
	
	for cauldron in _cauldrons:
		cauldron.connect("selected", self, "on_cauldron_selected")

	_portal.connect("selected", self, "on_portal_selected")


func on_ingredient_selected(ingredient_num: int) -> void:
	_selected_ingredient = ingredient_num
	emit_signal("ingredient_selected")


func on_cauldron_selected(cauldron_num: int) -> void:
	_selected_cauldron = cauldron_num
	if _selected_cauldron != -1:
		_player.change_click_position(_cauldrons[_selected_cauldron].player_position.global_position)


func on_portal_selected(_num: int) -> void:
	_player.change_click_position(_portal.player_position.global_position)	
	emit_signal("portal_selected")


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
