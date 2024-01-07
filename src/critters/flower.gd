class_name Flower
extends Node2D

@export var pollen_rate: float = 5.0
@export var pollen: float = randf_range(20.0, 60.0):
	set(value):
		if (value == pollen):
			return
		pollen = value
		_try_grow_seed()

@export var max_pollen: float = 100.0

@onready var bud : Node2D = $Body
@onready var target_scale : Vector2 = scale
@onready var pollen_burst : CPUParticles2D = $PollenBurst

@export var growth_rate: float = .2

var seed: Seed
var nearby: Node2D
var occupied : bool = false
var full_grown : bool = false:
	set(value):
		if value == full_grown:
			return
		full_grown = value
		
		if (full_grown):
			_try_grow_seed()

func _ready() -> void:
	scale = Vector2.ZERO

func _process(delta: float) -> void:
	pollen = clamp(pollen + (delta * pollen_rate), 0.0, max_pollen)
	
	if (!full_grown):
		if (target_scale == scale):
			full_grown = true
		else:
			scale = scale.move_toward(target_scale, delta * growth_rate)
	

func _spread_seed():
	pollen_burst.amount = int(pollen / 5.0)
	
	var target = Global.random_vector2().normalized() * randf_range(50.0, 90.0)
	var seed_tween = create_tween().set_ease(Tween.EASE_OUT)
	seed_tween.tween_property(seed, "position", target, .69)
	seed_tween.tween_callback(seed.activate)

	pollen = 0
	seed = null
	pollen_burst.emitting = true

func _on_body_area_entered(area: Area2D) -> void:
	if (area.owner is Flower):
		full_grown = true
		if scale.x < 0.1:
			queue_free()
	elif (area.owner is Player):
		if (seed != null):
			_spread_seed()

func _try_grow_seed():
	if (max_pollen == pollen and full_grown and seed == null):
		seed = Spawn.plant_seed()
		add_child.call_deferred(seed)
