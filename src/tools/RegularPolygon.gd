@tool
class_name RegularPolygonBody2D
extends Area2D

@export var radius: float = 25.0:
	get:
		return radius
	set(value):
		if value == radius:
			return
		
		radius = value
		_update_polygon.call_deferred()

@export var n_sides: int = 3:
	get:
		return n_sides
	set(value):
		if value == n_sides:
			return
		
		n_sides = value
		_update_polygon.call_deferred()

@onready var drawn : Polygon2D = $Drawn
@onready var collision : CollisionPolygon2D = $Collision

func _update_polygon():
	if n_sides < 3:
		n_sides = 3
		return

	var angle_increment = 2 * PI / n_sides

	var points: PackedVector2Array = []
	for i in range(n_sides):
		var angle = i * angle_increment
		var x = radius * cos(angle)
		var y = radius * sin(angle)
		
		points.push_back(Vector2(x, y))
	
	drawn.polygon = points
	collision.polygon = points
	
	drawn.queue_redraw()
