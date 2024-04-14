extends Node

var t

var player: KinematicBody2D

var ingredient_num: int = 5

enum INGREDIENTS_LIST {
	DRAGON_TONG,
	BAT_WINGS,
	GOAT,
	TOAD,
	STARDUST
}

var ingredients_dictionary = {
	INGREDIENTS_LIST.DRAGON_TONG : 	"dragon_tong",
	INGREDIENTS_LIST.BAT_WINGS: "bat_wings",
	INGREDIENTS_LIST.GOAT : "goat",
	INGREDIENTS_LIST.TOAD : "toad",
	INGREDIENTS_LIST.STARDUST : "stardust",
}

var selected_item: Node2D

var recipie: Array = []

var score

var life

func _ready():
	var file = File.new()
	var error = file.open("user://savegame.txt", File.WRITE)
	if error == OK:
		file.store_line("Hello, world!")
		file.close()
