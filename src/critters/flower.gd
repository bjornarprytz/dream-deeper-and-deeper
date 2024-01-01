class_name Flower
extends Node2D

@export var pollen_rate: float = 5.0
@export var pollen: float = 0.0
@export var max_pollen: float = 100.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pollen = clamp(pollen + (delta * pollen_rate), 0.0, max_pollen)
