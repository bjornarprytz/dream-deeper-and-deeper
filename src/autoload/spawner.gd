extends Node

@onready var circ_spawner = preload("res://critters/circ/circ.tscn")
@onready var tri_spawner = preload("res://critters/tri/tri.tscn")
@onready var quad_spawner = preload("res://critters/quad/quad.tscn")
@onready var pent_spawner = preload("res://critters/pent/pentagonia.tscn")
@onready var hex_spawner = preload("res://critters/hex/hexipremnum.tscn")
@onready var sept_spawner = preload("res://critters/sept/septodendron.tscn")
@onready var oct_spawner = preload("res://critters/oct/octstera.tscn")


@onready var critter_spawners : Array = [
	circ_spawner,
	tri_spawner,
	quad_spawner
]

@onready var flower_spawners : Array = [
	pent_spawner,
	hex_spawner,
	sept_spawner,
	oct_spawner
]

func pentagonia() -> Flower:
	return pent_spawner.instantiate() as Flower
