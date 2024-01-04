class_name Octstera
extends Flower

@onready var pattern : Polygon2D = $Body/Pattern

var _spheres : Array[Polygon2D] = []
var _time_spent : float = 0.0

func _ready() -> void:
	super()
	for c in pattern.get_children():
		_spheres.push_back(c)


func _process(delta: float) -> void:
	super(delta)
	var pattern_speed = pollen / max_pollen
	_time_spent += (pattern_speed * delta)
	
	for i in range(_spheres.size()):
		var s = _spheres[i]
		
		
		
		var x = pingpong(_time_spent * (i+1), 100.0) - 50.0
		var y = pingpong(_time_spent * (i+1), 100.0) - 50.0
		
		if (i % 2 == 0):
			x *= -1
		
		s.position = Vector2(x, y)
		
