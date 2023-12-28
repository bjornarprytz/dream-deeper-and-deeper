extends Node2D

# Density of flowers
@export var flower_density := 0.1
# Bias towards clustering (higher values create more clusters)
@export var cluster_bias := 2.0

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
	pass

func _populate_chunk(chunk_coord: Vector2i):
	print("TODO: Populate chunk ", chunk_coord)
	pass
