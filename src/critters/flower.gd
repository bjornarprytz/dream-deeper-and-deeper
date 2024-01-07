class_name Flower
extends Node2D

@export var pollen_rate: float = 5.0
@export var pollen: float = randf_range(20.0, 60.0)
@export var max_pollen: float = 100.0

@onready var bud : Node2D = $Body
@onready var target_scale : Vector2 = scale
@onready var pollen_burst : CPUParticles2D = $PollenBurst

@export var growth_rate: float = .2

var nearby: Node2D
var occupied : bool = false
var full_grown : bool = false

func _ready() -> void:
	scale = Vector2.ZERO

func _process(delta: float) -> void:
	pollen = clamp(pollen + (delta * pollen_rate), 0.0, max_pollen)
	
	if (!full_grown):
		scale = lerp(scale, target_scale, delta * growth_rate)
		
		if (scale == target_scale):
			full_grown = true

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
		full_grown = true
		if scale.x < 0.1:
			queue_free()
	elif (area.owner is Player):
		if (pollen == max_pollen):
			_spread_seeds()
