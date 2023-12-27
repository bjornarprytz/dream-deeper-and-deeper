class_name TriNose
extends Polygon2D


@onready var left_nostril : Node2D = $LeftNostril
@onready var right_nostril : Node2D = $RightNostril
@onready var nose_tip : Node2D = $Tip

var curve : Curve2D = Curve2D.new()
var nose_tip_root : Vector2
var wiggle : bool:
	get:
		return wiggle
	set(value):
		wiggle = value
		if !wiggle:
			var tween = create_tween()
			tween.tween_method(_wiggle_step, nose_tip.position.y - nose_tip_root.y, 0, 0.2)
		

@export var eagerness := 50.0
@export var flappyness := 4.0

func _ready() -> void:
	
	nose_tip_root = nose_tip.position
	
	var right_in = (nose_tip_root - right_nostril.position) * .4
	var left_out = (nose_tip_root - left_nostril.position) * .4
	
	curve.add_point(right_nostril.position, right_in, Vector2.ZERO)
	curve.add_point(left_nostril.position, Vector2.ZERO, left_out)
	curve.add_point(nose_tip.position)
	

var _time_spent : float

func _process(delta: float) -> void:
	_time_spent += delta
	if wiggle:
		_wiggle_step((pingpong((_time_spent * eagerness), flappyness*2.0) - flappyness))

func _wiggle_step(d: float):
	nose_tip.position.y = nose_tip_root.y + d
	queue_redraw()

func _draw() -> void:
	curve.set_point_position(2, nose_tip.position)
	
	var points : PackedVector2Array = curve.tessellate()
	var colors: PackedColorArray = []
	colors.resize(points.size())
	colors.fill(Color.WHITE)
	polygon = points
	vertex_colors = colors
	
