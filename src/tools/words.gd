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

var direction: Vector2:
	set(value):
		direction = value
		_particles.direction = value
		_aoe.rotation = direction.angle()
