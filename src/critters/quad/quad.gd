class_name Quad
extends Critter


@onready var senses_shape : CollisionShape2D = $Senses/Shape
@onready var emotions : Area2D = $Emotions
@onready var love: CPUParticles2D = $Love
@onready var state_chart: StateChart = $StateChart

@onready var poop_spawner : PackedScene = preload("res://critters/tokens/poop.tscn")

var current_engagement : Area2D

const max_happiness: float = 100.0
const max_fullness: Color = Color.WHITE
const move_factor = 30.0
const base_waddle_speed = .69

const separation_weight = .8
const cohesion_weight = .2
const alignment_weight = .2

var waddle_speed = base_waddle_speed
var direction: Vector2

var flowers : Array[Flower] = []

var fullness: Color = Color.BLACK:
	set(value):
		
		value = Color(value.r, value.g,value.b).clamp(Color.BLACK, Color.WHITE)
		
		if (!flowers.is_empty() and value.r < .6):
			state_chart.send_event("hunt")
		
		if (fullness == value):
			return

		happiness += ((value.r - fullness.r) * .4)
		fullness = value
		
		if (fullness == max_fullness):
			state_chart.send_event("poop")
		

var happiness: float = 0.0:
	set(value):
		if (value == happiness):
			return
		happiness = min(value, max_happiness)
		
		if (happiness > 90.0):
			$Body/Face.text = ":D"

var votes: int = 0

var _target: Vector2

func _ready() -> void:
	super()

func _input(event: InputEvent) -> void:
	if (event is InputEventMouseButton):
		_target = get_global_mouse_position()

func _physics_process(delta: float) -> void:
	if (current_engagement != null and !emotions.get_overlapping_areas().has(current_engagement)):
		_disengage()
	if (love.emitting):
		happiness += (delta * 10.0)
		

func _on_emotions_area_entered(area: Area2D) -> void:
	if (current_engagement == null and area.owner is Words):
		current_engagement = area
		love.emitting = true

func _on_emotions_area_exited(area: Area2D) -> void:
	if (current_engagement != null and area == current_engagement):
		_disengage()

func _disengage():
	current_engagement = null
	love.emitting = false

func _separation_vector(bodies: Array[Area2D]) ->Vector2:
	var v = Vector2.ZERO
	
	for b in bodies:
		if b is Body and b != my_body and b.owner is Critter or b.owner is Player:
			var their_size = (b as Body).radius * b.owner.scale.x
			var my_size = my_body.radius * scale.x
			var dir = global_position - b.global_position
			var distance = dir.length() - their_size - my_size
			v += ((dir).normalized() / distance)
	return v.normalized()

func _get_move_direction() -> Vector2:
	var areas = senses.get_overlapping_areas()
	
	var target_vector = (global_position - _target).normalized()
	var separation = _separation_vector(areas) * separation_weight
	var v = (separation
	+target_vector
	).normalized()
	return v

func _on_moving_state_physics_processing(delta: float) -> void:
	direction = _get_move_direction()
	
	fullness -= (Color.WHITE * 0.08 * delta)
	
	var angle_to_target = direction.angle()

	global_rotation = lerp(global_rotation, angle_to_target, delta)
	my_body.rotation = (pingpong(Time.get_ticks_msec() / 1000.0, PI / 4.0) - PI / 8.0) * waddle_speed
	
	var forward = Vector2(cos(global_rotation), sin(global_rotation))
	
	global_position = global_position.move_toward((global_position - (direction * 10.0)), delta * waddle_speed * move_factor)

func _on_meandering_state_entered() -> void:
	if flowers.is_empty():
		_set_random_target()

func _on_meandering_state_physics_processing(delta: float) -> void:
	var dir = (global_position - _target)
	
	if dir.length() < 50.0:
		_set_random_target()

func _on_hunting_state_entered() -> void:
	if (flowers.is_empty()):
		state_chart.send_event("move")
		print("Entered hunting state without any flowers.. aborting")
		return
	else:
		_target = flowers.pick_random().global_position
		$Body/Face.text = ":U"

func _on_hunting_state_physics_processing(delta: float) -> void:
	pass # Replace with function body.

func _on_grassing_state_physics_processing(delta: float) -> void:
	var f = pingpong((Time.get_ticks_msec() / 1000.0) * 5.0, 3.0)
	
	if (f > 2.0):
		$Body/Face.text = ":V"
	elif (f > 1.0):
		$Body/Face.text = ":Y"
	else:
		$Body/Face.text = ":I"
		
	var flowers_underfoot = _get_food_underfoot()

	if (flowers_underfoot.size() == 0):
		state_chart.send_event("move")
	else:
		for flower in flowers_underfoot:		
			flower.pollen -= (.2 * delta)
			fullness += (Color.WHITE * .2 * delta)

func _get_food_underfoot() -> Array[Flower]:
	var _fs: Array[Flower] = []
	for b in my_body.get_overlapping_areas():
		if b.owner is Flower and b.owner.pollen > 30.0:
			_fs.push_back(b.owner)
	return _fs

func _on_pooping_state_entered() -> void:	
	$Body/Face.text = "XI"
	
	var tween = create_tween()
	tween.tween_property(my_body, "modulate", Color.CRIMSON, 3.0)
	await tween.finished
	
	var poop = poop_spawner.instantiate() as Node2D
	
	get_tree().root.add_child(poop)
	poop.global_position = global_position
	
	tween.kill()
	tween = create_tween()
	tween.tween_property(my_body, "modulate", Color.WHITE, .4)
	
	await tween.finished
	$Body/Face.text = ":)"
	flowers.clear()
	_set_random_target()
	state_chart.send_event("move")

func _on_dancing_state_physics_processing(delta: float) -> void:
	pass # Replace with function body.


func _on_moving_state_entered() -> void:
	waddle_speed = 0.1
	var tween = create_tween()
	tween.tween_property(self, "waddle_speed", base_waddle_speed, 1.0)

func _set_random_target():
	_target = global_position + (Global.random_vector2() * randf_range(180.0, 240.0))

func _target_random_flower():
	if (flowers.size() > 0):
		_target = flowers.pick_random().global_position

func _on_senses_area_entered(area: Area2D) -> void:
	if (area.owner is Flower):
		flowers.push_back(area.owner)
		

func _on_senses_area_exited(area: Area2D) -> void:
	if (area.owner is Flower):
		flowers.erase(area.owner)

func _on_body_area_entered(area: Area2D) -> void:
	if (area.owner is Flower):
		var flower = area.owner as Flower
		
		if (flower.pollen > 20.0):
			state_chart.send_event("graze")
