extends Camera2D

@export var player : Player

@export var zoom_speed: float = 5.0
@export var zoom_in_level: Vector2 = Vector2(8.0, 8.0)
@export var zoom_out_level: Vector2 = Vector2.ONE

@onready var _base_zoom: Vector2 = zoom
@onready var _zoom_target: Vector2 = zoom

func _ready() -> void:
	assert(player != null)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	position = player.position
	
	zoom = lerp(zoom, _zoom_target, _delta * zoom_speed)
	

func _unhandled_input(event: InputEvent) -> void:
	if (event is InputEventJoypadMotion):
		if (event.axis == 4):
			_zoom_target = lerp(_base_zoom, zoom_out_level, event.axis_value)
		if (event.axis == 5):
			_zoom_target = lerp(_base_zoom, zoom_in_level, event.axis_value)
