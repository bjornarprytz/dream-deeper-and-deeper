class_name Pentagonia
extends Flower

var nearby: Node2D
@onready var bud : Node2D = $Body

@onready var pattern1 : Line2D = $Body/Pattern/A
@onready var pattern2 : Line2D = $Body/Pattern/B
@onready var pattern3 : Line2D = $Body/Pattern/C

@onready var pollen_burst : CPUParticles2D = $PollenBurst
@onready var target_scale : Vector2 = scale

@export var growth_rate: float = .2

var snap_back_tween : Tween
var _time_spent : float = 0.0
var halt_growth : bool = false


func _ready() -> void:
	scale = Vector2.ZERO

func _process(delta: float) -> void:
	super(delta)
	
	if (!halt_growth):
		scale = lerp(scale, target_scale, delta * growth_rate)
	
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
	
	for s in range(randi_range(1, 2)):
		var seed = Spawn.plant_seed()
		add_child.call_deferred(seed)
		var target = Global.random_vector2().normalized() * randf_range(50.0, 90.0)
		var seed_tween = create_tween().set_ease(Tween.EASE_OUT)
		seed_tween.tween_property(seed, "position", target, 1.0)
		seed_tween.tween_callback(seed.activate)

	pollen = 0
	pollen_burst.emitting = true

func _on_body_area_entered(area: Area2D) -> void:
	if (area.owner is Flower):
		halt_growth = true
		if scale.x < 0.1:
			queue_free()
	elif (area.owner is Player):
		if (pollen == max_pollen):
			_spread_seeds()
