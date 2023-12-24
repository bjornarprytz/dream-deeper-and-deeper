extends Polygon2D


@onready var left_nostril : Node2D = $LeftNostril
@onready var right_nostril : Node2D = $RightNostril
@onready var nose_tip : Node2D = $Tip


var curve : Curve2D = Curve2D.new()
var nose_tip_root : Vector2

func _ready() -> void:
	
	nose_tip_root = nose_tip.position
	
	var right_in = (nose_tip_root - right_nostril.position) * .25
	var left_out = (nose_tip_root - left_nostril.position) * .25
	
	curve.add_point(right_nostril.position, right_in, Vector2.ZERO)
	curve.add_point(left_nostril.position, Vector2.ZERO, left_out)
	curve.add_point(nose_tip.position)
	

var _time_spent : float

func _process(delta: float) -> void:
	_time_spent += delta
	nose_tip.position.y = nose_tip_root.y + (pingpong((_time_spent * 30.0), 20.0) - 10.0)
	queue_redraw()
	

func _draw() -> void:
	curve.set_point_position(2, nose_tip.position)
	
	var points : PackedVector2Array = curve.tessellate()
	var colors: PackedColorArray = []
	colors.resize(points.size())
	colors.fill(Color.AQUA)
	polygon = points
	vertex_colors = colors
	
