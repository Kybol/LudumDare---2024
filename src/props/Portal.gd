extends "res://src/props/Hoverable.gd"

onready var player_position: Position2D = $PlayerPosition
onready var _soup: Sprite = $Visuals/Soup
onready var _demon: Node2D = $Demon
onready var _success_particles: Particles2D = $SuccessBubbles

var _original_color: Color = "ff6e6e"
var _red: Color = "ff0000"

var _can_soup: bool = true

var _recipe_for_demon: Array = []

func _ready():
	_success_particles.emitting = false


func _on_Portal_selected(_num) -> void:
	if not Globals.player.has_soup() or not _can_soup: return
	
	yield(Globals.player, "target_reached")
	
	var soup: Node2D = Globals.player.remove_ingredient_from_hands()
	var soup_array: Array = Globals.player.ingredients_in_soup
	var is_success: int
	
	if Globals.recipie.size() > 0:
		is_success = check_soup(soup_array)
	else:
		return
	
	if is_success != -1:
		put_soup_in()
		_demon.spawn_demon(_recipe_for_demon)
		_recipe_for_demon = []
		_success_particles.emitting = true
		Globals.emit_signal("success", is_success)
	else:
		print("NO")


func check_soup(soup: Array) -> int:
	var soup_ingredients: Array = []
	
	for ingredient in soup:
		soup_ingredients.append(ingredient.ingredient_type)
		
	return compare_recipes(soup_ingredients)


func compare_recipes(soup: Array) -> int:
	var recipe: Array = Globals.recipie
	var recipe_2: Array = Globals.recipie_2
	var recipe_3: Array = Globals.recipie_3
	
	recipe.sort()
	recipe_2.sort()
	recipe_3.sort()
	soup.sort()
	
	_recipe_for_demon = soup
	
	if recipe == soup: return 1
	if recipe_2 == soup: return 2
	if recipe_3 == soup: return 3
	
	return -1


func put_soup_in() -> void:
	_can_soup = false
	
	change_soup_color()


func change_soup_color() -> void:
	var tween: SceneTreeTween = create_tween()
	Globals.t = tween.tween_property(_soup, "modulate", _red, 0.5)
	Globals.t = tween.tween_callback(self, "wait_for_success")


func wait_for_success() -> void:
	yield(get_tree().create_timer(1.5), "timeout")
	
	var tween: SceneTreeTween = create_tween()
	Globals.t = tween.tween_property(_soup, "modulate", _original_color, 0.5)
	Globals.t = tween.tween_callback(self, "success")


func success() -> void:
	_can_soup = true
