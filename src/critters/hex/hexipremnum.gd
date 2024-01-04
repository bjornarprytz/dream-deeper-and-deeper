class_name Hexipremnum
extends Flower

@onready var pattern_mask : Polygon2D = $Body/Pattern

var _patterns : Array[Line2D] = []
var _time_spent : float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	for p in pattern_mask.get_children():
		_patterns.push_back(p)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta)
	
	var pattern_speed = pollen / max_pollen
	_time_spent += (delta * pattern_speed)
	
	for i in range(_patterns.size()):
		_patterns[i].scale = Vector2.ONE * (pingpong(_time_spent * (i + 1), 2.0) - 1.0)
	

