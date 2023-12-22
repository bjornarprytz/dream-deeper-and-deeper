class_name Flower
extends Node2D

var nearby: Node2D
@onready var bud : Area2D = $Bud


var snap_back_tween : Tween

func _process(delta: float) -> void:
	if (nearby):
		bud.position = bud.position + (bud.global_position - nearby.position) * delta
	else:
		bud.position = bud.position - (bud.position) * delta


func _on_bud_body_entered(body: Node2D) -> void:
	nearby = body


func _on_bud_body_exited(body: Node2D) -> void:
	if (body == nearby):
		nearby = null
