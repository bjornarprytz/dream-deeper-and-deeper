class_name Words
extends Node2D

@onready var _particles : CPUParticles2D = $Particles
@onready var _aoe : Area2D = $AoE

var talking: bool:
	set(value):
		if (value == talking):
			return
		talking = value
		_particles.emitting = talking
		if (!talking):
			_aoe.monitorable = false
		else:
			_aoe.monitorable = true

func _ready() -> void:
	_aoe.monitorable = false
