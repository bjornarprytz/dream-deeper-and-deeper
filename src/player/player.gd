class_name Player
extends CharacterBody2D

var speed = 200
const rotate_speed = 20.0
const scale_multiplier = 1.8
const min_scale = 0.4

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
	elif input_vector != Vector2.ZERO:
		if is_pivoting:
			_pivot(input_vector.x * delta)
		if is_color_change:
			_change_color(input_vector)
		_change_scale(input_vector)

func _pivot(momentum: float):
	_orbit(rotation + (momentum * rotate_speed))
	
func _change_color(input_vector : Vector2):
	modulate = Global.color_from_unit_circle(input_vector)

func _change_scale(input_vector: Vector2):
	var flate_magnitude = max(((input_vector) - (Vector2.ONE / 2.0)).length(), min_scale)
	
	var flate_factor = flate_magnitude * input_vector.sign().y * scale_multiplier
	if !is_flating:
		flate_factor = 1.0
		
	scale = Vector2.ONE
	if is_squeezing:
		scale -= input_vector
	scale *= flate_factor
	

var scale_tween : Tween
var pivot_tween : Tween
var pivot_point : Vector2
var color_tween : Tween

var is_squeezing : bool:
	set(value):
		if value == is_squeezing:
			return
		is_squeezing = value
		
		if (!is_squeezing):
			scale_tween = create_tween().set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
			scale_tween.tween_property(self, "scale", Vector2.ONE, .69)
		else:
			if (scale_tween != null):
				scale_tween.kill()
		
var is_pivoting : bool:
	set(value):
		if value == is_pivoting:
			return

		is_pivoting = value
		
		if (!is_pivoting):
			pivot_tween = create_tween().set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
			pivot_tween.tween_method(_orbit, rotation, 0.0, .69)
			pivot_tween.tween_callback(set_deferred.bind("pivot_point", position))
		else:
			if pivot_tween != null:
				pivot_tween.kill()
			var angle = randf_range(0.0, 2.0 * PI)
			var radius = randf_range(0.0, $Body.radius)
			pivot_point = position + Vector2(radius * sin(angle), radius * cos(angle))
			
var is_color_change : bool:
	set(value):
		if value == is_color_change:
			return
		
		is_color_change = value
		
		if (!is_color_change):
			color_tween = create_tween()
			color_tween.tween_property(self, "modulate", Global.palette_character, 5.0)
		else:
			if (color_tween != null):
				color_tween.kill()

var is_flating : bool:
	set(value):
		if value == is_flating:
			return
		is_flating = value
		
		if (!is_flating):
			scale_tween = create_tween().set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
			scale_tween.tween_property(self, "scale", Vector2.ONE, .69)
		else:
			if (scale_tween != null):
				scale_tween.kill()

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
