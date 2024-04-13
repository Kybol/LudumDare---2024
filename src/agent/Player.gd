extends KinematicBody2D

signal target_reached

export (float) var speed: float = 200.0

#var _velocity: Vector2 = Vector2.ZERO
var _click_position: Vector2 = Vector2.ZERO
var _is_at_destination: bool = false


func _ready():
	_click_position = Vector2(global_position.x, global_position.y)


func _physics_process(delta):
	if Input.is_action_just_pressed("left_click"):
		_is_at_destination = false
		_click_position = get_global_mouse_position()
	
	var target_position = (_click_position - global_position).normalized()
	
	if global_position.distance_to(_click_position) > 3:
		move_and_slide(target_position * speed)
		
	if _is_at_destination: return
	
	if global_position.distance_to(_click_position) < 3:
		_is_at_destination = true
		emit_signal("target_reached")
		
