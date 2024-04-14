extends Node2D


var _tuto_02_scene: String = "res://src/screens/menu/Tuto_02.tscn"




func _on_Next_pressed():
	Globals.t = get_tree().change_scene(_tuto_02_scene)
