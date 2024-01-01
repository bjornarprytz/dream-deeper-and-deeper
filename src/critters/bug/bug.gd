class_name Bug
extends Node2D

@onready var left_wing : Node2D = $LeftWing
@onready var right_wing : Node2D = $RightWing

@onready var left_base_scale : float = left_wing.scale.y
@onready var right_base_scale : float = right_wing.scale.y


@export var form : String:
	set(value):
		if (value.length() == 0):
			return
		if (value.length() > 1):
			value = value[0]
		
		$RightWing/Form.text = value
		$LeftWing/Form.text = value
		
		form = value

const flap_speed := 15.0

var _time_passed : float = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_time_passed += delta
	
	var flap = pingpong(_time_passed * flap_speed, 1.0)
	
	left_wing.scale.y = left_base_scale * flap
	right_wing.scale.y = right_base_scale * flap

