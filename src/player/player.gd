class_name Player
extends CharacterBody2D

var speed = 200

func _ready() -> void:
	assert(Global.player == null)
	Global.player = self

func _physics_process(delta: float) -> void:
	velocity = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") * speed
	var collided = move_and_slide()
	
	if (collided):
		var collider = get_slide_collision(0).get_collider()
		if (collider):
			collider.sleeping = false
			collider.apply_force(collider.position - position)
	
