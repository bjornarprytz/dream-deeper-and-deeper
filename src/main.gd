extends Node2D

# Density of flowers
@export var flower_density := 0.1
# Bias towards clustering (higher values create more clusters)
@export var cluster_bias := 2.0

@onready var flowers : Node = $Flowers
@onready var critters : Node = $Critters

func _ready() -> void:
	Global.chunk_changed.connect(_on_new_chunk)

func _on_new_chunk(_old: Vector2i, _new: Vector2i):
	_clean_up_stragglers()
	var old_collection = Global.get_chunk_collection(_old)
	var new_collection = Global.get_chunk_collection(_new)
	
	for chunk in new_collection:
		if (!old_collection.has(chunk)):
			_populate_chunk(chunk)

func _clean_up_stragglers():
	print("TODO: Remove stragglers")

func _populate_chunk(chunk_coord: Vector2i):
	print("TODO: Populate chunk ", chunk_coord)
	
	var seed = rand_from_seed(Global.get_chunk_seed(chunk_coord))
	
	const n_flowers = 6
	const n_critters = 3
	
	for i in range(n_flowers):
		var flower = Spawn.flower()
		flowers.add_child(flower)
		flower.global_position = Global.get_random_pos_within_chunk(chunk_coord)
	
	for i in range(n_critters):
		var critter = Spawn.critter()
		critters.add_child(critter)
		critter.global_position = Global.get_random_pos_within_chunk(chunk_coord)
		

