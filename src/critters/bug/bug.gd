class_name Bug
extends Node2D

class PollenSack:
	var _pollen : Dictionary = {}
	var _max_amount : float
	
	func _init(max_amount: float = 20.0) -> void:
		_max_amount = max_amount
		
		for c in Global.palette_plants:
			_pollen[c] = 0.0
	
	func uncollected_colors() -> Array[Color]:
		var uncollected : Array[Color] = []
		for c in _pollen.keys():
			if _pollen[c] == 0.0:
				uncollected.push_back(c)
		return uncollected
	
	func random_collected_color_except(color : Color) -> Color:
		var candidates : Array[Color] = []
		var collected : Array[Color] = []
		for c in _pollen.keys():
			if c != color:
				candidates.push_back(c)
		for c in candidates:
			if (_pollen[c] > 0.0):
				collected.push_back(c)
		if collected.is_empty():
			return candidates.pick_random()
		return collected.pick_random()
	
	func is_full(color: Color) -> float:
		return _pollen[color] == _max_amount
	
	func add(color: Color, amount: float):
		_pollen[color] = clamp(_pollen[color] + amount, 0.0, _max_amount)
	
	func drain(color: Color) -> float:
		var amount = _pollen[color]
		_pollen[color] = 0.0
		return amount

const max_energy := 100.0
@onready var energy = max_energy

@onready var left_wing : Node2D = $LeftWing
@onready var right_wing : Node2D = $RightWing
@onready var state_chart : StateChart = $StateChart

@onready var left_base_scale : float = left_wing.scale.y
@onready var right_base_scale : float = right_wing.scale.y
@onready var flight_speed : float = randf_range(3.0, 12.0)
@onready var rotation_strength : float = randf_range(8.0, 12.0)

@export var recovery_rate : float = 10.0
@export var exertion_rate : float = 5.0

@export var form : String:
	set(value):
		if (value.length() == 0):
			return
		if (value.length() > 1):
			value = value[0]
		
		$RightWing/Form.text = value
		$LeftWing/Form.text = value
		
		form = value

const flying_flap_speed := 10.0
const take_off_flap_speed := 15.0
const landing_flap_speed := 5.0
const landed_flap_speed := 1.0

var target : Vector2
var threats : Array[Node2D]
var flower : Flower
var pollen_sack : PollenSack

var flap_speed := flying_flap_speed

var _time_passed : float = 0.0

func _ready() -> void:
	pollen_sack = PollenSack.new()

func _process(delta: float) -> void:
	_time_passed += delta
	
	var flap = pingpong(_time_passed * flap_speed, 1.0)
	
	left_wing.scale.y = left_base_scale * flap
	right_wing.scale.y = right_base_scale * flap

func _process_landing(delta: float) -> void:
	flap_speed = lerp(flap_speed, landing_flap_speed, delta)
	
	if (flower == null or flower.occupied):
		state_chart.send_event("abort_landing")
		return
		
	var proximity = global_position.distance_to(flower.global_position)
	
	if (proximity < 2.0):
		state_chart.send_event("land")

func _on_landed_state_entered() -> void:
	flower.occupied = true
	var flower_color = flower.modulate
	var pollen_to_give = pollen_sack.random_collected_color_except(flower_color)
	
	if (pollen_to_give):
		flower.pollen += pollen_sack.drain(pollen_to_give)

func _process_landed(delta: float) -> void:
	energy = clamp(energy + (delta * recovery_rate), 0.0, max_energy)
	flap_speed = lerp(flap_speed, landed_flap_speed, delta)
	
	var flower_color = flower.modulate
	pollen_sack.add(flower_color, delta)
	
	if (energy == max_energy):
		state_chart.send_event("fly")

func _on_landed_state_exited() -> void:
	flower.occupied = false

func _process_fleeing(delta: float) -> void:
	flap_speed = lerp(flap_speed, take_off_flap_speed, delta)
	
	var closest_threat: Node2D
	var closest_proximity = 10000.0
	
	for t in threats:
		var proximity = t.global_position.distance_to(global_position)
		if (proximity < closest_proximity):
			closest_proximity = proximity
			target = (global_position - (global_position - t.global_position)) * 5.0

func _process_searching(delta: float) -> void:
	flap_speed = lerp(flap_speed, take_off_flap_speed, delta)
	
	var distance = global_position.distance_to(target)
	
	if (distance < 20.0 or distance > 100.0):
		_set_random_target()

func _process_flying(delta: float) -> void:
	energy = clamp(energy - (delta * exertion_rate), 0.0, max_energy)
	
	var forward_vector = Vector2(cos(global_rotation), sin(global_rotation))
	
	global_position -= forward_vector * flap_speed * flight_speed * delta
	
	var angle_to_target = (global_position - target).angle_to(forward_vector)
	
	global_rotation = lerp(global_rotation, global_rotation - angle_to_target, delta * rotation_strength)

func _on_sensors_area_entered(area: Area2D) -> void:
	var thing = area.owner
	
	if (thing is Flower and _flower_is_candidate(thing)):
		flower = thing
		target = flower.global_position
		state_chart.send_event("landing")
	elif(thing is Critter or thing is Player):
		threats.push_back(thing)
		state_chart.send_event("flee")

func _flower_is_candidate(f: Flower) -> bool:
	if (f.occupied or !f.full_grown or flower != null):
		return false

	var flower_color = f.modulate
	var uncollected_colors = pollen_sack.uncollected_colors()
	
	return uncollected_colors.is_empty() or uncollected_colors.has(flower_color)


func _on_searching_state_entered() -> void:
	flower = null
	_set_random_target()

func _set_random_target():
	target = global_position + (Global.random_vector2() * randf_range(60.0, 80.0))

func _on_sensors_area_exited(area: Area2D) -> void:
	var thing = area.owner
	if(thing is Critter or thing is Player):
		threats.erase(thing)
		if threats.is_empty():
			state_chart.send_event("search")

