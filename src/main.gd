extends Node2D

@onready var flowers : Node2D = $Flowers
@onready var critters : Node2D = $Critters
@onready var bugs : Node2D = $Bugs


func _ready() -> void:
	Spawn.flowers = flowers
	Spawn.critters = critters
	Spawn.bugs = bugs
	
	Global.chunk_changed.connect(_on_new_chunk)
	
	_populate_chunk(Vector2i.ZERO)
	
	#for chunk in Global.get_chunk_collection(Vector2i(0,0)):
	#	_populate_chunk(chunk)

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
	var seed = rand_from_seed(Global.get_chunk_seed(chunk_coord))
	
	const n_flowers = 12
	const n_critters = 2
	const n_bugs = 4
	
	for i in range(n_flowers):
		var flower = Spawn.flower()
		flowers.add_child(flower)
		flower.global_position = Global.get_random_pos_within_chunk(chunk_coord)
	
	for i in range(n_critters):
		var critter = Spawn.critter()
		critters.add_child(critter)
		critter.global_position = Global.get_random_pos_within_chunk(chunk_coord)
	
	for i in range(n_bugs):
		var bug = Spawn.bug()
		bugs.add_child(bug)
		bug.global_position = Global.get_random_pos_within_chunk(chunk_coord)

