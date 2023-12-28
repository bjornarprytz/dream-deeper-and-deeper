extends Node2D


@export var density := 2 # Patterns per screen
@export var n_lines := 2
@export var thickness := 10.0
@export var gap := 30.0

var _anchor : Vector2
var _chunk_size : Vector2

func _ready() -> void:
	_chunk_size = Global.get_chunk_size()
	_anchor = Vector2(randf_range(0, _chunk_size.x), randf_range(0, _chunk_size.y))
	
	Global.chunk_changed.connect(_redraw)
	
	modulate = Global.palette_pattern

func _redraw(_old: Vector2i, _new: Vector2i):
	queue_redraw()

# Called whenever the node is redrawn
func _draw() -> void:
	var chunk_coord = Global.current_chunk_coord
	
	var rows = range(chunk_coord.y-1, chunk_coord.y + 2)
	var columns = range(chunk_coord.x-1, chunk_coord.x + 2)
	for j in rows:
		for i in columns:
			var offset_x = i * _chunk_size.x
			var offset_y = j * _chunk_size.y

			# Draw vertical lines
			for k in range(-n_lines, n_lines + 1):
				var x = _anchor.x + (i * _chunk_size.x) + (k * gap)
				draw_line(Vector2(x, offset_y), Vector2(x, offset_y + _chunk_size.y), Color(1, 1, 1, .5), thickness)

			# Draw horizontal lines
			for k in range(-n_lines, n_lines + 1):
				var y = _anchor.y + (j * _chunk_size.y) + (k * gap)
				draw_line(Vector2(offset_x, y), Vector2(offset_x + _chunk_size.x, y), Color(1, 1, 1, .5), thickness)
