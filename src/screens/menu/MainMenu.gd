extends Node2D

var _main_scene: String = "res://src/screens/Main.tscn"


func _on_PlayButton_button_up():
	get_tree().change_scene(_main_scene)
