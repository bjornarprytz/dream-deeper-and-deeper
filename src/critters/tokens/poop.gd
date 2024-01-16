class_name Poop extends Node2D

@onready var smell : Area2D = $Smell


var available : bool = true:
	set(value):
		if  value == available:
			return
		
		available = value
		smell.set_deferred("monitorable", value)

var hp = 100.0:
	set(value):
		hp = value
		if hp < 0.0:
			queue_free()

