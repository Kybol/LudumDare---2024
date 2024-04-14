extends Node2D

signal selected(num)

export (int) var num: int

var is_idle: bool = true 

onready var _visuals: Node2D = $Visuals
onready var _area_2d: Area2D = $Area2D
onready var _highlight = $Visuals/Highlight
onready var _sound = $sound

var _is_hovered: bool = false

func _ready() -> void:
	_highlight.modulate.a = 0.0

	Globals.t = _area_2d.connect("mouse_entered", self, "_on_Area2D_mouse_entered")
	Globals.t = _area_2d.connect("mouse_exited", self, "_on_Area2D_mouse_exited")


func _process(_delta) -> void:
	if not is_idle: return
	
	if Input.is_action_just_pressed("left_click") and _is_hovered:
		emit_signal("selected", num)
		_sound.play()


func _on_Area2D_mouse_entered() -> void:
	if not is_idle: return
	
	_is_hovered = true
	
	_highlight.modulate.a = 1.0
	_visuals.scale = Vector2(1.05, 1.05)


func _on_Area2D_mouse_exited() -> void:
	if not is_idle: return
	
	_is_hovered = false
	
	_highlight.modulate.a = 0.0
	_visuals.scale = Vector2(1.0, 1.0)

