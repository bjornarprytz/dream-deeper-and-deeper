class_name Critter
extends Node2D

@export var speed : float

@onready var my_body : Body = $Body
@onready var senses : Area2D = $Senses

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
