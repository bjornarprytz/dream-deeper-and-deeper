class_name Static
extends Node

var palette_character : Color
var palette_pattern: Color
var palette_critters: Array[Color]
var palette_plants: Array[Color]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	palette_character = Color.BLUE
	palette_pattern = Color.INDIAN_RED
	palette_critters = [
		_random_color(),
		_random_color(),
		_random_color()
		]

	palette_plants = [
		_random_color(),
		_random_color(),
		_random_color(),
		_random_color()
		]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _random_color() -> Color:
	return Color(randf(), randf(), randf())
