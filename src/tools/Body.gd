@tool
class_name Body
extends Area2D

@export var radius: float = 25.0:
	get:
		return radius
	set(value):
		if value == radius:
			return
		if value < 0.0:
			value = 1.0
		
		radius = value
		_update_polygon.call_deferred()

@export var n_sides: int = 3:
	get:
		return n_sides
	set(value):
		if value == n_sides:
			return
		
		if (value < 3):
			value = 3
		
		n_sides = value
		_update_polygon.call_deferred()

@export var disable_collider: bool:
	set(value):
		if (value == disable_collider):
			return
		disable_collider = value
		_update_polygon.call_deferred()

@export var polygon: PackedVector2Array:
	get:
		return drawn.polygon

@export var border_color: Color:
	set(value):
		if (border_color == value):
			return
		border_color = value
		_update_polygon.call_deferred()
		
@export var border_width: float:
	set(value):
		if (border_width == value):
			return
		border_width = value
		_update_polygon.call_deferred()

@onready var drawn : Polygon2D = $Drawn
@onready var collision : CollisionPolygon2D = $Collision
@onready var border : Line2D = $Drawn/Border

func _update_polygon():
	if !is_node_ready():
		return
		
	collision.disabled = disable_collider

	border.width = border_width
	border.default_color = border_color

	var angle_increment = 2 * PI / n_sides

	var points: PackedVector2Array = []
	for i in range(n_sides):
		var angle = i * angle_increment
		var x = radius * cos(angle)
		var y = radius * sin(angle)
		
		points.push_back(Vector2(x, y))
	
	drawn.polygon = points
	collision.polygon = points
	border.points = points
	
	drawn.queue_redraw()
