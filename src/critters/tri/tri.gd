class_name Tri
extends Critter


var player : Player

var move_direction

func _ready() -> void:
	modulate = Global.palette_critters[0]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (player):
		var next_pos = position.move_toward(player.position, speed * delta)
		move_direction = (global_position - next_pos )
		position = next_pos
	
		look_at(player.position)

func _on_senses_body_entered(body: Node2D) -> void:
	if body is Player:
		player = body
func _on_senses_body_exited(body: Node2D) -> void:
	if body == player:
		player = null
