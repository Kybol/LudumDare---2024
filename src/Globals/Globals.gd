extends Node

signal success(num)
signal parchment_died
signal fail

var t

var player: KinematicBody2D

var ingredient_num: int = 5
var ingredients_in_soup: Array = []

var starting_min_time: float = 8.0
var starting_max_time: float = 10.0

enum INGREDIENTS_LIST {
	DRAGON_TONG,
	BAT_WINGS,
	GOAT,
	TOAD,
	STARDUST
}

#var ingredients_dictionary = {
#	INGREDIENTS_LIST.DRAGON_TONG : 	"dragon_tong",
#	INGREDIENTS_LIST.BAT_WINGS: "bat_wings",
#	INGREDIENTS_LIST.GOAT : "goat",
#	INGREDIENTS_LIST.TOAD : "toad",
#	INGREDIENTS_LIST.STARDUST : "stardust",
#}

var ingredients_dictionary = {
	INGREDIENTS_LIST.DRAGON_TONG : "res://src/assets/Props/parchment/icone_flamme.png",
	INGREDIENTS_LIST.BAT_WINGS: "res://src/assets/Props/parchment/icone_ailes.png",
	INGREDIENTS_LIST.GOAT : "res://src/assets/Props/parchment/icone_cornes.png",
	INGREDIENTS_LIST.TOAD : "res://src/assets/Props/parchment/icone_toxique.png",
	INGREDIENTS_LIST.STARDUST : "res://src/assets/Props/parchment/icone_nocturne.png",
}

var selected_item: Node2D

var recipie: Array = []
var recipie_2: Array = []
var recipie_3: Array = []

var highest_score = 0

var life: int = 3

func save_highest_score():
	var file = File.new()
	var error = file.open("user://savegame.txt", File.WRITE)
	if error == OK:
		file.store_32()
		file.close(highest_score)


