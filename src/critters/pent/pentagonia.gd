class_name Pentagonia
extends Flower

@onready var pattern1 : Line2D = $Body/Pattern/A
@onready var pattern2 : Line2D = $Body/Pattern/B
@onready var pattern3 : Line2D = $Body/Pattern/C

var _time_spent : float = 0.0

func _ready() -> void:
	scale = Vector2.ZERO

func _process(delta: float) -> void:
	super(delta)
	
	var pattern_speed = pollen / max_pollen
	_time_spent += (pattern_speed * delta)
	
	var a_scale = pingpong(_time_spent, 2.0) - 1.0
	var c_scale = pingpong(_time_spent * 2.0, 2.0) - 1.0
	var b_scale = pingpong(_time_spent * 3.0, 2.0) - 1.0
	
	pattern1.scale = Vector2(a_scale, a_scale)
	pattern2.scale = Vector2(b_scale, b_scale)
	pattern3.scale = Vector2(c_scale, c_scale)


