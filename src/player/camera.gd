extends Camera2D

@export var player : Player

func _ready() -> void:
	assert(player != null)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position = player.position
