class_name Pentagonia
extends Flower

var nearby: Node2D
@onready var bud : Node2D = $Body

@onready var pattern1 : Line2D = $Body/Pattern/A
@onready var pattern2 : Line2D = $Body/Pattern/B
@onready var pattern3 : Line2D = $Body/Pattern/C

var snap_back_tween : Tween

var _time_spent : float = 0.0

func _process(delta: float) -> void:
	super(delta)
	_time_spent += delta
	
	var pattern_speed = pollen / max_pollen
	var progress = pattern_speed * _time_spent
	
	var a_scale = pingpong(progress, 2.0) - 1.0
	var c_scale = pingpong(progress * 2.0, 2.0) - 1.0
	var b_scale = pingpong(progress * 3.0, 2.0) - 1.0
	
	pattern1.scale = Vector2(a_scale, a_scale)
	pattern2.scale = Vector2(b_scale, b_scale)
	pattern3.scale = Vector2(c_scale, c_scale)
	


func _on_body_body_entered(body: Node2D) -> void:
	if (body.owner is Flower):
		return
	nearby = body.owner

func _on_body_body_exited(body: Node2D) -> void:
	if (body.owner == nearby):
		nearby = null
