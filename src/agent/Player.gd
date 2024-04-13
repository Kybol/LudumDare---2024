extends KinematicBody2D

signal target_reached
signal started_moving

var click_position: Vector2 = Vector2.ZERO

export (float) var speed: float = 300.0

onready var _ingredient_placeholder: Position2D = $IngredientPlaceHolder

var _previous_click_position: Vector2 = Vector2.ZERO

var _is_at_destination: bool = false
var _is_stopped: bool = false

var _ingredient: Sprite = null


func _ready():
	Globals.player = self
	click_position = Vector2(global_position.x, global_position.y)


func _physics_process(_delta):
	if _is_stopped: 
		click_position = _previous_click_position
		_is_stopped = false
	elif Input.is_action_just_pressed("left_click"):
		emit_signal("started_moving")
		_is_at_destination = false
		_previous_click_position = click_position
		click_position = get_global_mouse_position()
	
	var target_position = (click_position - global_position).normalized()
	
	if global_position.distance_to(click_position) > 3:
		move_and_slide(target_position * speed)
		
	if _is_at_destination: return
	
	if global_position.distance_to(click_position) < 3:
		_is_at_destination = true
		emit_signal("target_reached")


func change_click_position(new_position: Vector2) -> void:
	_is_stopped = false
	click_position = new_position


func stop_moving() -> void:
	_is_stopped = true


func put_ingredient_in_hands(ingredient: Sprite) -> void:
	if hands_are_full(): remove_ingredient_from_hands()
	
	call_deferred("add_child", ingredient)
	yield(ingredient, "tree_entered")
	
	ingredient.global_position = _ingredient_placeholder.global_position
	_ingredient = ingredient


func remove_ingredient_from_hands() -> void:
	if not hands_are_full(): return
	
	_ingredient.queue_free()
	_ingredient = null


func hands_are_full() -> bool:
	return is_instance_valid(_ingredient)
