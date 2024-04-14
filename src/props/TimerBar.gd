extends Line2D

signal time_to_die

var min_time = 3.0
var max_time = 5.0

onready var _recipie_timer: Timer = $"../RecipieTime"

var _is_active: bool = true

func reset_bar() -> void:
	points[1].x = 100
	_recipie_timer.start(rand_range(min_time, max_time))
	_is_active = true

func stop_bar() -> void:
	points[1].x = 0
	_recipie_timer.stop()
	_is_active = false


func _decrease() -> void:
	points[1].x -= 10


func _is_time_to_die() -> bool:
	return points[1].x == 0


func _on_RecipieTime_timeout():
	if not _is_active: return
	_decrease()
	
	if _is_time_to_die():
		_is_active = false
		emit_signal("time_to_die")
