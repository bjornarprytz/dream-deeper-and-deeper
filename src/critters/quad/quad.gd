class_name Quad
extends Critter

@onready var senses : Area2D = $Senses
@onready var senses_shape : CollisionShape2D = $Senses/Shape
@onready var emotions : Area2D = $Emotions
@onready var my_body : Body = $Body
@onready var love: CPUParticles2D = $Love
@onready var state_chart: StateChart = $StateChart

var current_engagement : Area2D

const max_happiness: float = 100.0
const max_fullness: Color = Color.WHITE
const move_factor = 30.0
const base_waddle_speed = .69

const separation_weight = .7
const ego_weight = .8
const cohesion_weight = .4
const alignment_weight = .5
const flower_weight = 1.2

var waddle_speed = base_waddle_speed
var direction: Vector2

var flock : Array[Quad] = []
var flowers : Array[Flower] = []

var fullness: Color = Color.BLACK
var happiness: float = 0.0

var votes: int = 0

var _target: Vector2
var _time_spent : float = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	_time_spent += delta
	
	if (current_engagement != null and !emotions.get_overlapping_areas().has(current_engagement)):
		_disengage()

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

func _cohesion_vector() ->Vector2:
	var v = Vector2.ZERO
	for q in flock:
		v += q.global_position
	if flock.size() > 0:
		v /= flock.size() # Centroid
		v -= global_position # Direction to centroid

	return v.normalized()
func _alignment_vector() -> Vector2:
	var v = Vector2.ZERO
	for q in flock:
		v += q.direction * q.flock.size()
	if flock.size() > 0:
		v /= flock.size()
	
	return v.normalized()
	
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
	
	var target_vector = global_position - (global_position - _target).normalized() * flower_weight
	var separation = _separation_vector(areas) * separation_weight
	#var cohesion = _cohesion_vector() * cohesion_weight
	var alignment = _alignment_vector() * alignment_weight
	var forward_vector = Vector2(cos(global_rotation), sin(global_rotation)) * ego_weight
	return (separation 
	#+ cohesion 
	+ alignment 
	+ forward_vector).normalized()

func _on_moving_state_physics_processing(delta: float) -> void:
	global_position -= direction * delta * waddle_speed * move_factor
	
	var angle_to_target = direction.angle()
	rotation = lerp(rotation, rotation - angle_to_target, delta)
	
	my_body.rotation = (pingpong(_time_spent, PI / 4.0) - PI / 8.0) * waddle_speed

func _on_meandering_state_entered() -> void:
	if flowers.is_empty():
		_set_random_target()

func _on_flocking_state_physics_processing(delta: float) -> void:
	direction = _get_move_direction()

func _on_meandering_state_physics_processing(delta: float) -> void:
	var dir = (global_position - _target)
	
	direction = dir.normalized()
	
	if flowers.is_empty() and dir.length() < 80.0:
		_set_random_target()

func _on_grassing_state_physics_processing(delta: float) -> void:
	pass # Replace with function body.

func _on_pooping_state_physics_processing(delta: float) -> void:
	pass # Replace with function body.

func _on_dancing_state_physics_processing(delta: float) -> void:
	pass # Replace with function body.


func _on_moving_state_entered() -> void:
	waddle_speed = 0.1
	var tween = create_tween()
	tween.tween_property(self, "waddle_speed", base_waddle_speed, 1.0)

func _set_random_target():
	_target = global_position + (Global.random_vector2() * randf_range(100.0, 120.0))

func _target_random_flower():
	if (flowers.size() > 0):
		_target = flowers.pick_random().global_position

func _on_senses_area_entered(area: Area2D) -> void:
	if (area.owner is Quad and area.owner != self):
		state_chart.send_event("flock")
		flock.push_back(area.owner)
	elif (area.owner is Flower):
		flowers.push_back(area.owner)
		

func _on_senses_area_exited(area: Area2D) -> void:
	if (area.owner is Quad):
		flock.erase(area.owner)
	elif (area.owner is Flower):
		flowers.erase(area.owner)


