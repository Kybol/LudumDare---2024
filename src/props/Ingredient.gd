extends Node2D

var is_idle: bool = true 

export (String) var description: String

onready var _visuals: Node2D = $Visuals
onready var _area_2d: Area2D = $Area2D
onready var _highlight = $Visuals/Highlight


func _ready():
	_highlight.modulate.a = 0.0

	_area_2d.connect("mouse_entered", self, "_on_Area2D_mouse_entered")
	_area_2d.connect("mouse_exited", self, "_on_Area2D_mouse_exited")


func _on_Area2D_mouse_entered():
	if not is_idle: return
	
	_highlight.modulate.a = 1.0
	_visuals.scale = Vector2(1.1, 1.1)


func _on_Area2D_mouse_exited():
	if not is_idle: return
	
	_highlight.modulate.a = 0.0
	_visuals.scale = Vector2(1.0, 1.0)

