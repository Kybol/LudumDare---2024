extends KinematicBody2D

signal target_reached
signal started_moving

var click_position: Vector2 = Vector2.ZERO
var ingredients_in_soup: Array = []

var can_interact: bool = true

export (float) var speed: float = 300.0

onready var _ingredient_placeholder: Position2D = $IngredientPlaceHolder
onready var _animation_sprite: AnimatedSprite = $AnimatedSprite

var _previous_click_position: Vector2 = Vector2.ZERO

var _is_at_destination: bool = false
var _is_stopped: bool = false
var _has_soup: bool = false


var _ingredient: Node2D = null

onready var walk = $walk

func _ready():
	Globals.player = self
	click_position = Vector2(global_position.x, global_position.y)


func _physics_process(_delta):
	if _is_stopped: 
		click_position = _previous_click_position
		_is_stopped = false
		can_interact = true		
	elif Input.is_action_just_pressed("left_click"):
		emit_signal("started_moving")
		_animation_sprite.play("Walk")
		can_interact = true
		_is_at_destination = false
		_previous_click_position = click_position
		click_position = get_global_mouse_position()
		walk.play()
	var target_position = (click_position - global_position).normalized()
	
	if global_position.distance_to(click_position) > 3:
		Globals.t = move_and_slide(target_position * speed)
		
	if _is_at_destination: return
	
	if global_position.distance_to(click_position) < 3:
		_animation_sprite.play("Idle")		
		_is_at_destination = true
		emit_signal("target_reached")


func change_click_position(new_position: Vector2) -> void:
	_is_stopped = false
	click_position = new_position


func stop_moving() -> void:
	_is_stopped = true
	walk.stop()


func put_ingredient_in_hands(ingredient, is_soup: bool = false) -> void:
	if hands_are_full(): 
		Globals.t = remove_ingredient_from_hands()
	
	call_deferred("add_child", ingredient)
	yield(ingredient, "tree_entered")
	
	ingredient.global_position = _ingredient_placeholder.global_position
	_ingredient = ingredient
	
	if is_soup: 
		Globals.ingredients_in_soup = _ingredient.ingredient_list.duplicate(true)
		_has_soup = true


func remove_ingredient_from_hands() -> Node2D:
	if not hands_are_full(): return null
	
	var old_ingredient: Node2D
	old_ingredient = _ingredient.duplicate()
	
	_ingredient.modulate.a = 0.0
	
	ingredients_in_soup = []
	
	_has_soup = false
	_ingredient.queue_free()
	_ingredient = null
	
	return old_ingredient


func hands_are_full() -> bool:
	return is_instance_valid(_ingredient)


func has_soup() -> bool:
	return _has_soup
