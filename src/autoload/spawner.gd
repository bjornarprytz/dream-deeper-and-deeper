class_name Spawner
extends Node

@onready var _circ_spawner = preload("res://critters/circ/circ.tscn")
@onready var _tri_spawner = preload("res://critters/tri/tri.tscn")
@onready var _quad_spawner = preload("res://critters/quad/quad.tscn")
@onready var _pent_spawner = preload("res://critters/pent/pentagonia.tscn")
@onready var _hex_spawner = preload("res://critters/hex/hexipremnum.tscn")
@onready var _sept_spawner = preload("res://critters/sept/septodendron.tscn")
@onready var _oct_spawner = preload("res://critters/oct/octstera.tscn")


@onready var _critter_spawners : Array[PackedScene] = [
	_circ_spawner,
	_tri_spawner,
	_quad_spawner
]

@onready var _flower_spawners : Array[PackedScene] = [
	_pent_spawner,
	_hex_spawner,
	_sept_spawner,
	_oct_spawner
]

func flower() -> Flower:
	return _randomize_flower(
		_flower_spawners.pick_random().instantiate() as Flower)

func critter() -> Critter:
	return _randomize_critter(
		_critter_spawners.pick_random().instantiate() as Critter)


static func _randomize_flower(flower: Flower) -> Flower:
	var s = randf_range(.15, .4)
	flower.scale = Vector2(s, s)
	flower.modulate = Global.palette_plants.pick_random()
	return flower

static func _randomize_critter(critter: Critter) -> Critter:
	var s = randf_range(.8, 1.1)
	critter.scale = Vector2(s, s)
	critter.modulate = Global.palette_critters.pick_random()
	return critter
