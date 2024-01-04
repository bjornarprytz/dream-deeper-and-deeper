class_name Septodendron
extends Flower

@onready var pattern : Polygon2D = $Body/Pattern

var curves : Array[Curve2D] = []
var lines : Array[Line2D] = []

func _ready() -> void:
	super()

	var n_points = pattern.polygon.size()
	for i in range(n_points):
		var curve = Curve2D.new()
		var origin = pattern.polygon[i]
		var target = pattern.polygon[(i + 4) % n_points]
		var out_v = pattern.polygon[(i + 2) % n_points] / 1.5
		
		curve.add_point(origin, Vector2.ZERO, out_v)
		curve.add_point(target)
		curves.push_back(curve)
		
		var line = Line2D.new()
		line.points = curve.tessellate() 
		line.default_color = Color.from_string("b2b2b2", Color.BLACK)
		line.width = 3.0
		line.closed = false
		pattern.add_child(line)
		
		lines.push_back(line)

func _process(delta: float) -> void:
	super(delta)
	
	var pattern_speed = pollen / max_pollen
	
	var n_lines = lines.size()
	
	for i in range(n_lines):
		lines[i].rotate(delta * (i+1) * pattern_speed)
