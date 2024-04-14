extends "res://src/props/Hoverable.gd"

export (String) var description: String
export (PackedScene) var sprite_scene: PackedScene

var is_selected: bool = false

func _ready() -> void:
	._ready()


func _on_Ingredient_selected(_num) -> void:
	if is_selected: return
	
	is_selected = true
	yield(Globals.player, "target_reached")
	
	is_selected = false
	if not Globals.player.can_interact: return
	
	pick_ingredient()


func pick_ingredient() -> void:
	var sprite: IgredientType = sprite_scene.instance()
	Globals.player.put_ingredient_in_hands(sprite)
