class_name Circ
extends Critter

@onready var seed_spawner : PackedScene = preload("res://critters/tokens/seed_rigid_body.tscn")
var _target: Vector2
var direction : Vector2

func _ready() -> void:
	speed = 30.0

func _on_singing_state_physics_processing(delta: float) -> void:
	pass # Replace with function body.


func _on_meandering_state_physics_processing(delta: float) -> void:
	pass # Replace with function body.


func _on_approaching_state_physics_processing(delta: float) -> void:
	pass # Replace with function body.


func _on_body_area_entered(area: Area2D) -> void:
	var thing = area.owner
	if thing is Poop:
		thing.reparent.call_deferred($Belly/Contents)
		thing.global_position = global_position
		thing.available = false
	elif thing is Seed:
		thing.queue_free()
		var seed = seed_spawner.instantiate()
		$Belly/Contents.add_child.call_deferred(seed)


func _on_planting_state_physics_processing(delta: float) -> void:
	pass # Replace with function body.


func _separation_vector(bodies: Array[Area2D]) ->Vector2:
	var v = Vector2.ZERO
	
	for b in bodies:
		if b is Body and b != my_body and b.owner is Critter or b.owner is Player:
			var their_size = (b as Body).radius * b.owner.scale.x
			var my_size = my_body.radius * scale.x
			var dir = global_position - b.global_position
			var distance = dir.length() - their_size - my_size
			v += ((dir).normalized() / distance)
	return v.normalized()

func _get_move_direction() -> Vector2:
	var areas = senses.get_overlapping_areas()
	
	var target_vector = (global_position - _target).normalized()
	var separation = _separation_vector(areas) * .8
	var v = (separation
	+target_vector
	).normalized()
	return v

func _on_moving_state_physics_processing(delta: float) -> void:
	direction = _get_move_direction()
	
	var angle_to_target = direction.angle()

	global_rotation = lerp(global_rotation, angle_to_target, delta)
	
	var forward = Vector2(cos(global_rotation), sin(global_rotation))
	
	global_position = global_position.move_toward((global_position - (direction * 10.0)), delta * speed)
	
	if (_target - global_position).length() < 40.0:
		_set_random_target()


func _set_random_target():
	_target = global_position + (Global.random_vector2() * randf_range(180.0, 240.0))
