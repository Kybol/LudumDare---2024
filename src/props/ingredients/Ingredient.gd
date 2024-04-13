extends "res://src/props/Hoverable.gd"

export (String) var description: String
export (PackedScene) var sprite_scene: PackedScene


func _ready() -> void:
	._ready()

func _on_Ingredient_selected(_num) -> void:
	yield(Globals.player, "target_reached")
	
	pick_ingredient()


func pick_ingredient() -> void:
	var sprite = sprite_scene.instance()
	Globals.player.put_ingredient_in_hands(sprite)
