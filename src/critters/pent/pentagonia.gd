class_name Pentagonia
extends Flower

var nearby: Node2D
@onready var bud : Node2D = $Body


var snap_back_tween : Tween

func _process(delta: float) -> void:
	if (nearby):
		bud.position = bud.position + (bud.global_position - nearby.position) * delta
	else:
		bud.position = bud.position - (bud.position) * delta


func _on_body_body_entered(body: Node2D) -> void:
	if (body.owner is Flower):
		return
	nearby = body.owner


func _on_body_body_exited(body: Node2D) -> void:
	if (body.owner == nearby):
		nearby = null
