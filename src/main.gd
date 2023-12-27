extends Node2D

func _ready() -> void:
	Global.chunk_changed.connect(_on_new_chunk)
	


func _on_new_chunk(chunk_coords: Vector2i):
	pass
