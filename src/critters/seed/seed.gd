class_name Seed
extends Node2D

@onready var sensors : Area2D = $Sensors

func activate():
	await get_tree().create_timer(randf_range(10.0, 25.0)).timeout
	take_root()

func take_root():
	var flower = Spawn.pentagonia() # Revert to Flower
	
	Spawn.flowers.add_child(flower)
	flower.global_position = global_position

	queue_free()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
