class_name Static
extends Node

signal chunk_changed(old: Vector2i, new: Vector2i)

var player : Player

var palette_character : Color
var palette_pattern: Color
var palette_critters: Array[Color]
var palette_plants: Array[Color]

var current_chunk_coord : Vector2i = Vector2i.ZERO

func get_chunk_size() -> Vector2:
	return get_viewport().size
	
func get_current_chunk(global_pos : Vector2) -> Vector2i:
	var chunk_size = get_chunk_size()
	
	assert(chunk_size.x != 0 and chunk_size.y != 0)
	
	return Vector2i(floor(global_pos.x / chunk_size.x), floor(global_pos.y / chunk_size.y))

func get_chunk_rect(chunk_coords: Vector2i) -> Rect2:
	var pos : Vector2
	var chunk_size = get_chunk_size()
	
	pos.x = chunk_coords.x * chunk_size.x
	pos.y = chunk_coords.y * chunk_size.y
	
	return Rect2(pos, chunk_size)

func get_random_pos_within_chunk(chunk_coords: Vector2i) -> Vector2:
	var rect = get_chunk_rect(chunk_coords)
	
	var x = randf_range(rect.position.x, rect.position.x + rect.size.x)
	var y = randf_range(rect.position.y, rect.position.y + rect.size.y)
	
	return Vector2(x, y)

func get_chunk_seed(chunk_coords: Vector2i) -> int:
	var a : float = (chunk_coords.x + 1337)
	var b : float
	if (chunk_coords.y == 0):
		b = -648.0
	else:
		b = chunk_coords.y * -69
	
	return int((a / b) * 1000000)

func get_chunk_collection(chunk_coords: Vector2i) -> Array[Vector2i]:
	var x = chunk_coords.x
	var y = chunk_coords.y
	return [
		Vector2i(x-1, y-1), Vector2i(x, y-1), Vector2i(x+1, y-1),
		Vector2i(x-1, y), Vector2i(x, y), Vector2i(x+1, y),
		Vector2i(x-1, y+1), Vector2i(x, y+1), Vector2i(x+1, y+1)
	]

func _update_chunk_coord() -> void:	
	assert(player != null)
	
	var new_coord := get_current_chunk(player.global_position)
		
	var old_coord = current_chunk_coord
	current_chunk_coord = new_coord
	
	if (old_coord != new_coord):
		chunk_changed.emit(old_coord, new_coord)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	palette_character = Color.SKY_BLUE
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
