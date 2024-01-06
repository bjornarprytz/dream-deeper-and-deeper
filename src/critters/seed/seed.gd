class_name Seed
extends Node2D

@onready var sensor : Area2D = $Sensor

@onready var base_scale : Vector2 = global_scale

func activate():
	sensor.connect("area_entered", _on_sensor_area_entered)
	var tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)
	tween.tween_method(_wobble, 0.0, 2.0, randf_range(10.0, 25.0))
	tween.tween_callback(take_root)

func take_root():
	var flower = Spawn.flower()
	
	Spawn.flowers.add_child(flower)
	flower.global_position = global_position

	queue_free()

func _wobble(t: float):
	var wobble = (pingpong(t, 0.1)) * 2.0 
	
	global_scale = base_scale + (Vector2.ONE * wobble)
	

func _on_sensor_area_entered(area: Area2D) -> void:
	if (area.owner is Critter or area.owner is Player):
		reparent.call_deferred(area.owner)
		global_scale = base_scale
		sensor.disconnect("area_entered", _on_sensor_area_entered)
