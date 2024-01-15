class_name Circ
extends Critter


var _target: Vector2

func _on_singing_state_physics_processing(delta: float) -> void:
	pass # Replace with function body.


func _on_meandering_state_physics_processing(delta: float) -> void:
	pass # Replace with function body.


func _on_approaching_state_physics_processing(delta: float) -> void:
	pass # Replace with function body.


func _on_body_area_entered(area: Area2D) -> void:
	pass # Replace with function body.


func _on_planting_state_physics_processing(delta: float) -> void:
	pass # Replace with function body.


func _on_moving_state_physics_processing(delta: float) -> void:
	pass # Replace with function body.


func _set_random_target():
	_target = global_position + (Global.random_vector2() * randf_range(180.0, 240.0))
