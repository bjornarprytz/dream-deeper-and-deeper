class_name Pentagonia
extends Flower

var nearby: Node2D
@onready var bud : Node2D = $Body

@onready var pattern1 : Line2D = $Body/Pattern/A
@onready var pattern2 : Line2D = $Body/Pattern/B
@onready var pattern3 : Line2D = $Body/Pattern/C

@onready var pollen_burst : CPUParticles2D = $PollenBurst

var snap_back_tween : Tween

var _time_spent : float = 0.0

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

func _spread_seeds():	
	pollen_burst.amount = int(pollen / 5.0)
	pollen = 0
	pollen_burst.emitting = true

func _on_body_body_entered(body: Node2D) -> void:
	if (body.owner is Critter or body is Player):
		if (pollen == max_pollen):
			_spread_seeds()

