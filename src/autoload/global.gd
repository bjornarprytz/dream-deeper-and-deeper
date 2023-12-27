class_name Static
extends Node

signal chunk_changed(coords: Vector2i)

var player : Player

var palette_character : Color
var palette_pattern: Color
var palette_critters: Array[Color]
var palette_plants: Array[Color]

var current_chunk_coord : Vector2i = Vector2i.ZERO

func get_chunk_size():
	return get_viewport().size
	
func get_current_chunk(global_pos : Vector2) -> Vector2i:
	var chunk_size = get_chunk_size()
	
	assert(chunk_size.x != 0 and chunk_size.y != 0)
	
	return Vector2i(floor(global_pos.x / chunk_size.x), floor(global_pos.y / chunk_size.y))

func _update_chunk_coord() -> void:	
	assert(player != null)
	
	var new_coord := get_current_chunk(player.global_position)
	
	var should_emit_signal = new_coord != current_chunk_coord
	
	current_chunk_coord = new_coord
	
	if (should_emit_signal):
		chunk_changed.emit(current_chunk_coord)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	palette_character = Color.BLUE
	palette_pattern = Color.INDIAN_RED
	palette_critters = [
		_random_color(),
		_random_color(),
		_random_color()
		]

	palette_plants = [
		_random_color(),
		_random_color(),
		_random_color(),
		_random_color()
		]

const REFRESH_INTERVAL := 1.0

var _time_acc := 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_time_acc = _time_acc + delta
	
	if (_time_acc >= REFRESH_INTERVAL):
		_update_chunk_coord()
		_time_acc = 0.0

func _random_color() -> Color:
	return Color(randf(), randf(), randf())
