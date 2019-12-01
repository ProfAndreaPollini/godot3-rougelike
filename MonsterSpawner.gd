extends Node2D

export var MONSTER : PackedScene



func spawn() -> void:
	var monster = MONSTER.instance()
	monster.global_position = global_position
	
	get_parent().add_child(monster)