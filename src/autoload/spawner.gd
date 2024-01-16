class_name Spawner
extends Node

var flowers: Node2D
var critters: Node2D
var bugs: Node2D


@onready var _circ_spawner = preload("res://critters/circ/circ.tscn")
@onready var _tri_spawner = preload("res://critters/tri/tri.tscn")
@onready var _quad_spawner = preload("res://critters/quad/quad.tscn")
@onready var _pent_spawner = preload("res://critters/pent/pentagonia.tscn")
@onready var _hex_spawner = preload("res://critters/hex/hexipremnum.tscn")
@onready var _sept_spawner = preload("res://critters/sept/septodendron.tscn")
@onready var _oct_spawner = preload("res://critters/oct/octstera.tscn")

@onready var _bug_spawner = preload("res://critters/bug/bug.tscn")

@onready var _seed_spawner = preload("res://critters/tokens/seed.tscn")

@onready var _critter_spawners : Array[PackedScene] = [
	#_circ_spawner,
	#_tri_spawner,
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

func pentagonia() -> Pentagonia:
	return _randomize_flower(
		_pent_spawner.instantiate() as Pentagonia)

func critter() -> Critter:
	return _randomize_critter(
		_critter_spawners.pick_random().instantiate() as Critter)

func bug() -> Bug:
	return _randomize_bug(
		_bug_spawner.instantiate() as Bug
	)

func plant_seed():
	return _seed_spawner.instantiate() as Seed

static func _randomize_flower(flower: Flower) -> Flower:
	var s = randf_range(.3, .5)
	flower.scale = Vector2(s, s)
	flower.rotation_degrees = randf_range(0.0, 360.0)
	flower.modulate = Global.palette_plants.pick_random()
	return flower

static func _randomize_critter(critter: Critter) -> Critter:
	var s = randf_range(.9, 1.2)
	critter.scale = Vector2(s, s)
	critter.modulate = Global.palette_critters.pick_random()
	return critter

static func _randomize_bug(bug: Bug) -> Bug:
	var s = randf_range(.9, 1.1)
	bug.scale = Vector2(s, s)
	bug.modulate = Global.palette_critters.pick_random() * 0.5
	var chars := "abcdefghijklnopqrstuxyzæøå123456789"
	bug.form = chars[randi_range(0, chars.length()-1)]
	return bug

