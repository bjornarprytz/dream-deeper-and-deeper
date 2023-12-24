extends Area2D


var player : Player
@onready var nose : TriNose = $Nose

var speed : float = 100.0
var move_direction


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (player):
		var next_pos = position.move_toward(player.position, speed * delta)
		move_direction = (global_position - next_pos )
		position = next_pos
	
		look_at(player.position)


func _on_senses_body_entered(body: Node2D) -> void:
	if body is Player:
		nose.wiggle = true
		player = body
func _on_senses_body_exited(body: Node2D) -> void:
	if body == player:
		nose.wiggle = false
		player = null
