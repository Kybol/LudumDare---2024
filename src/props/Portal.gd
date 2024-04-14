extends "res://src/props/Hoverable.gd"

onready var _soup: Sprite = $Visuals/Soup
onready var _demon: Node2D = $Demon

var _original_color: Color = "ff6e6e"
var _red: Color = "ff0000"

var _can_soup: bool = true

var _recipe_for_demon: Array = []


func _on_Portal_selected(_num) -> void:
	if not Globals.player.has_soup() or not _can_soup: return
	
	yield(Globals.player, "target_reached")
	
	var soup: Node2D = Globals.player.remove_ingredient_from_hands()
	var soup_array: Array = Globals.player.ingredients_in_soup
	var is_success: bool
	
	if Globals.recipie.size() > 0:
		is_success = check_soup(soup_array)
	else:
		return
	
	if is_success:
		put_soup_in()
		_demon.spawn_demon(_recipe_for_demon)
		_recipe_for_demon = []
		Globals.emit_signal("success")
	else:
		print("NO")


func check_soup(soup: Array) -> bool:
	var recipie: Array = Globals.recipie.duplicate(true)
	_recipe_for_demon = Globals.recipie.duplicate()
	var soup_ingredients: Array = []
	
	for ingredient in soup:
		soup_ingredients.append(ingredient.ingredient_type)
		
	return compare_recipes(recipie, soup_ingredients)


func compare_recipes(recipe: Array, soup: Array) -> bool:
	recipe.sort()
	soup.sort()

	return recipe == soup


func put_soup_in() -> void:
	_can_soup = false
	
	change_soup_color()


func change_soup_color() -> void:
	var tween: SceneTreeTween = create_tween()
	Globals.t = tween.tween_property(_soup, "modulate", _red, 0.5)
	Globals.t = tween.tween_callback(self, "wait_for_success")


func wait_for_success() -> void:
	yield(get_tree().create_timer(0.5), "timeout")
	
	var tween: SceneTreeTween = create_tween()
	Globals.t = tween.tween_property(_soup, "modulate", _original_color, 0.5)
	Globals.t = tween.tween_callback(self, "success")


func success() -> void:
	_can_soup = true
