class_name Segment
extends Node2D

@onready var shape : Polygon2D = $Polygon
@export var prev_segment : Node2D
@export var prev_size : float
var speed := 5.0

var next_segment : Segment

const size_when_child_pops := 10.0
const child_size_factor := .69
const child_modulate_factor := .9
const buffer := 4.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(child_size_factor < 1.0)

var internval_passing = 0.0
func _process(delta: float) -> void:
	var target_vector = prev_segment.global_position - global_position
	
	if (target_vector).length() > _allowed_distance():
		global_position = global_position.move_toward(global_position + target_vector.limit_length(_allowed_distance()), delta * speed)

	internval_passing += delta
	
	if (internval_passing >= 1.0):
		internval_passing = 0.0
		if (next_segment == null and _get_size() >= size_when_child_pops):
			next_segment = self.duplicate() as Segment
			next_segment.prev_segment = self
			next_segment.prev_size = _get_size() / 2.0
			next_segment.scale = (scale * child_size_factor)
			next_segment.speed = speed
			next_segment.modulate = modulate * child_modulate_factor
			add_sibling.call_deferred(next_segment)

func _allowed_distance():
	return ((_get_size() / 2.0) + prev_size) + buffer

func shake():
	var tween = create_tween()
	tween.tween_method(_shake_step, 1.0, 0.0, 1.0)
	if (next_segment):
		await get_tree().create_timer(.2).timeout
		next_segment.shake()

func _shake_step(f: float):
	shape.position = Global.random_vector2() * f * 3.0

func _get_size() -> float:
	var size = shape.polygon.size()
	
	if (size < 2):
		return 0.0
	
	var one = shape.polygon[0]
	var other = shape.polygon[size/2]
	
	return (one.distance_to(other) * global_scale.x)
