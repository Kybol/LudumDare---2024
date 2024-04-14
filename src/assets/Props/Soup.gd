extends Sprite

var ingredient_list: Array = []


func set_ingredient_list(list: Array) -> void:
	ingredient_list = list.duplicate()


func get_ingredient_list() -> Array:
	print("ing list :", ingredient_list)	
	return ingredient_list
