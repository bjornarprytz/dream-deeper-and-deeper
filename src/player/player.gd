class_name Player
extends CharacterBody2D

var speed = 200

func _ready() -> void:
	assert(Global.player == null)
	Global.player = self
	modulate = Global.palette_character

func _physics_process(delta: float) -> void:
	var input_vector := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_vector * speed
	
	if !_is_emoting():
		var collided = move_and_slide()
		
		if (collided):
			var collider = get_slide_collision(0).get_collider()
			if (collider):
				collider.sleeping = false
				collider.apply_force(collider.position - position)
	else:
		if is_squeezing:
			_squeeze(input_vector)
		if is_pivoting:
			_pivot(input_vector.x * delta)

func _squeeze(input_vector: Vector2):
	scale = Vector2.ONE - input_vector

func _pivot(momentum: float):
	_orbit(rotation + momentum)

var squeeze_tween : Tween
var pivot_tween : Tween
var pivot_point : Vector2
var color_tween : Tween
var flate_tween : Tween

var is_squeezing : bool:
	set(value):
		if value == is_squeezing:
			return
		var was_squeezing = is_squeezing
		is_squeezing = value
		
		if (was_squeezing and !is_squeezing):
			squeeze_tween = create_tween().set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
			squeeze_tween.tween_property(self, "scale", Vector2.ONE, .69)
		elif (!was_squeezing and is_squeezing and squeeze_tween != null):
			squeeze_tween.kill()
			
		
var is_pivoting : bool:
	set(value):
		if value == is_pivoting:
			return
		var was_pivoting = is_pivoting
		is_pivoting = value
		
		if (was_pivoting and !is_pivoting):
			pivot_tween = create_tween().set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
			pivot_tween.tween_method(_orbit, rotation, 0.0, .69)
			pivot_point = position
		elif (!was_pivoting and is_pivoting and pivot_tween != null):
			pivot_tween.kill()
			var angle = randf_range(0.0, 2.0 * PI)
			var radius = randf_range(0.0, $Body.radius)
			pivot_point = position + Vector2(radius * sin(angle), radius * cos(angle))
			print("Pivot at ", pivot_point)
			
var is_color_change : bool
var is_flating : bool

func _is_emoting():
	return is_squeezing or is_pivoting or is_color_change or is_flating

func _input(event: InputEvent) -> void:
	if (event is InputEventJoypadButton):
		match (event.button_index):
			JOY_BUTTON_A:
				is_squeezing = event.pressed
			JOY_BUTTON_B:
				is_pivoting = event.pressed
			JOY_BUTTON_X:
				is_flating = event.pressed
			JOY_BUTTON_Y:
				is_color_change = event.pressed


func _orbit(rot: float):
	# Translate the node to the pivot point
	var original_position = position
	position = position - pivot_point

	rotation = rot

	# Translate the node back to its original position
	position = position.rotated(deg_to_rad(rot)) + pivot_point
