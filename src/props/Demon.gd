extends Node2D

signal done

onready var _bases: Node2D = $Bases
onready var _bases_array: Array = $Bases.get_children()
#onready var _accessories_small: Node2D = $Bases
onready var _accessories_small: Array = $AccessoriesSmall.get_children()

var _original_position: Vector2

func _ready():
	_original_position = global_position
	
	for sprite in _bases_array:
		sprite.modulate.a = 0.0
	
	for sprite in _accessories_small:
		sprite.modulate.a = 0.0


func spawn_demon(recipe: Array) -> void:
	var sprites_to_spawn: Array
	var accessories: Array = _accessories_small
	var is_small: bool
	
	if recipe.has(Globals.INGREDIENTS_LIST.DRAGON_TONG):
		is_small = false
		sprites_to_spawn.append(_bases_array[1])
	else:
		is_small = true
		sprites_to_spawn.append(_bases_array[0])
	
	if recipe.has(Globals.INGREDIENTS_LIST.BAT_WINGS):
		var wings: Sprite = accessories[0]
		sprites_to_spawn.append(_accessories_small.append(wings))
	
	if recipe.has(Globals.INGREDIENTS_LIST.STARDUST):
		var stars: Sprite = accessories[1]
		sprites_to_spawn.append(_accessories_small.append(stars))
		
	if recipe.has(Globals.INGREDIENTS_LIST.TOAD):
		var toxic: Sprite = accessories[2]
		sprites_to_spawn.append(_accessories_small.append(toxic))
		
	var tween: SceneTreeTween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	for sprite in sprites_to_spawn:
		Globals.t = tween.tween_property(sprite, "modulate:a", 1.0, 0.5)
		Globals.t = tween.tween_callback(self, "wait_before_end", [sprite])


func wait_before_end(sprite: Sprite) -> void:
	yield(get_tree().create_timer(2.0), "timeout")
	
	var tween: SceneTreeTween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	Globals.t = tween.tween_property(sprite, "modulate:a", 0.0, 0.5)
	Globals.t = tween.tween_property(self, "global_position.y", _original_position.y + 20.0, 0.5)
	Globals.t = tween.tween_callback(self, "done")


func done() -> void:
	global_position = _original_position
	emit_signal("done")
	
