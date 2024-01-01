class_name Seed
extends Node2D

@onready var sensors : Area2D = $Sensors

func try_root():
	const proximity_threshold = 140.0
	var score := 100.0
	
	var areas = sensors.get_overlapping_areas()
	
	var flower = Spawn.flower()
	
	for b in areas:
		if b.owner is Flower:
			var size = b.scale.length()
			var d = b.global_position.distance_to(global_position)
			var proximity = proximity_threshold - d
			score -= (proximity * size)
	
	print(score)
	
	if (score <= 0.0):
		flower.queue_free()
	else:
		Spawn.flowers.add_child(flower)
		flower.global_position = global_position
	
	queue_free()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
