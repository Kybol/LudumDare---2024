extends Node2D

signal done

var sprites_to_spawn: Array = []

onready var _bases: Node2D = $Bases
onready var _bases_array: Array = $Bases.get_children()
#onready var _accessories_small: Node2D = $Bases
onready var _accessories_small: Array = $AccessoriesSmall.get_children()
onready var _accessories_mid: Array = $AccessoriesMid.get_children()
onready var _accessories_big: Array = $AccessoriesBig.get_children()

onready var _sound1 = $sound1
onready var _sound2 = $sound2

var _original_position: Vector2

func _ready():
	_original_position = global_position
	
	modulate.a = 0.0


func spawn_demon(recipe: Array) -> void:
	var accessories: Array 
	
	if recipe.has(Globals.INGREDIENTS_LIST.DRAGON_TONG):
		accessories = _accessories_big
		sprites_to_spawn.append(_bases_array[2])
	elif recipe.has(Globals.INGREDIENTS_LIST.GOAT):
		accessories = _accessories_small
		sprites_to_spawn.append(_bases_array[0])
	elif recipe.has(Globals.INGREDIENTS_LIST.STARDUST):
		accessories = _accessories_mid
		sprites_to_spawn.append(_bases_array[1])
	else:
		accessories = _accessories_small
		sprites_to_spawn.append(_bases_array[0])
	
	if recipe.has(Globals.INGREDIENTS_LIST.BAT_WINGS):
		var wings: Sprite = accessories[0]
		sprites_to_spawn.append(wings)
	
	if recipe.has(Globals.INGREDIENTS_LIST.STARDUST):
		var stars: Sprite = accessories[1]
		sprites_to_spawn.append(stars)
		
	if recipe.has(Globals.INGREDIENTS_LIST.TOAD):
		var toxic: Sprite = accessories[2]
		sprites_to_spawn.append(toxic)
	
	for sprite in sprites_to_spawn:
		sprite.visible = true
		
	var tween: SceneTreeTween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	var tween2: SceneTreeTween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)	
	Globals.t = tween.tween_property(self, "modulate:a", 1.0, 0.5)	
	Globals.t = tween2.tween_property(self, "global_position:y", _original_position.y - 20.0, 0.0)	
	Globals.t = tween2.tween_property(self, "global_position:y", _original_position.y, 0.5)	
	Globals.t = tween.tween_callback(self, "wait_before_end")
	_sound1.play()
	
	


func wait_before_end() -> void:
	yield(get_tree().create_timer(3.0), "timeout")
	
	var tween: SceneTreeTween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	var tween2: SceneTreeTween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	Globals.t = tween.tween_property(self, "modulate:a", 0.0, 0.5)
	Globals.t = tween2.tween_property(self, "global_position:y", _original_position.y + 20.0, 0.5)
	Globals.t = tween.tween_callback(self, "done")


func done() -> void:
	for sprite in sprites_to_spawn:
		sprite.visible = false

	sprites_to_spawn = []
	global_position = _original_position
	emit_signal("done")
