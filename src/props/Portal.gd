extends "res://src/props/Hoverable.gd"

onready var _soup: Sprite = $Visuals/Soup

var _original_color: Color = "ff6e6e"
var _red: Color = "ff0000"

var _can_soup: bool = true


func _on_Portal_selected(_num) -> void:
	if not Globals.player.has_soup() or not _can_soup: return
	
	yield(Globals.player, "target_reached")
	
	var soup: Node2D = Globals.player.remove_ingredient_from_hands()
	var is_success: bool
	
	if Globals.recipie.size() > 0:
		is_success = check_soup(soup)
	else:
		return
	
	if is_success:
		put_soup_in()
	else:
		print("NO")


func check_soup(soup: Node2D) -> bool:
	print("soup ? ", soup)
	for ingredient in soup.get_ingredient_list():
		if not Globals.recipie.has(ingredient.ingredient_type):
			return false
	return true


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
