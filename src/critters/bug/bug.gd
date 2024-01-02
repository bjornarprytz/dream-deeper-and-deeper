class_name Bug
extends Node2D

const max_energy := 100.0
@onready var energy = max_energy

@onready var left_wing : Node2D = $LeftWing
@onready var right_wing : Node2D = $RightWing
@onready var state_chart : StateChart = $StateChart

@onready var left_base_scale : float = left_wing.scale.y
@onready var right_base_scale : float = right_wing.scale.y

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
const landing_flap_speed := 12.0
const landed_flap_speed := 1.0

var target : Vector2
var threats : Array[Node2D]
var flower : Flower

var flap_speed := flying_flap_speed

var _time_passed : float = 0.0

func _process(delta: float) -> void:
	_time_passed += delta
	
	var flap = pingpong(_time_passed * flap_speed, 1.0)
	
	left_wing.scale.y = left_base_scale * flap
	right_wing.scale.y = right_base_scale * flap

func _process_landing(delta: float) -> void:
	flap_speed = lerp(flap_speed, landing_flap_speed, delta)
	
	if (flower == null):
		state_chart.send_event("abort_landing")
		
	var proximity = global_position.distance_to(flower.global_position)
	
	if (proximity < 2.0):
		state_chart.send_event("land")

func _process_landed(delta: float) -> void:
	energy += clamp(delta * recovery_rate, 0.0, max_energy)
	
	if (energy == max_energy):
		state_chart.send_event("fly")

func _process_fleeing(delta: float) -> void:
	flap_speed = lerp(flap_speed, take_off_flap_speed, delta)
	
	var closest_threat: Node2D
	var closest_proximity = 10000.0
	
	for t in threats:
		var proximity = t.global_position.distance_to(global_position)
		if (proximity < closest_proximity):
			closest_proximity = proximity
			target = (global_position - (t.global_position - global_position)) * 50.0
	

func _process_searching(delta: float) -> void:
	flap_speed = lerp(flap_speed, take_off_flap_speed, delta)
	
	if (global_position.distance_to(target) < 10.0):
		_set_random_target()

func _process_flying(delta: float) -> void:
	energy -= clamp(delta * exertion_rate, 0.0, max_energy)
	
	var forward_vector = Vector2(cos(rotation), sin(rotation))
	
	position += forward_vector * flap_speed * delta
	
	rotation = lerp(rotation, global_position.angle_to_point(target), delta)


func _on_sensors_area_entered(area: Area2D) -> void:
	var thing = area.owner
	
	if (thing is Flower and flower == null):
		flower = thing
		target = flower.global_position
		state_chart.send_event("landing")
	elif(thing is Critter or thing is Player):
		threats.push_back(thing)
		state_chart.send_event("flee")


func _on_searching_state_entered() -> void:
	flower = null
	_set_random_target()

func _set_random_target():
	target = Global.random_vector2() * randf_range(40.0, 80.0)

func _on_sensors_area_exited(area: Area2D) -> void:
	var thing = area.owner
	if(thing is Critter or thing is Player):
		threats.erase(thing)
		if threats.is_empty():
			state_chart.send_event("search")



