extends Node2D



var _main_scene: String = "res://src/screens/Main.tscn"
var _tuto_01_scene: String = "res://src/screens/menu/Tuto_01.tscn"



func _on_Play_pressed():
	Globals.t = get_tree().change_scene(_tuto_01_scene)


func _on_Quit_pressed():
	get_tree().quit()
