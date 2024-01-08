class_name Quad
extends Critter

@onready var emotions : Area2D = $Emotions
var current_engagement : Area2D



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if (current_engagement != null and !emotions.get_overlapping_areas().has(current_engagement)):
		_disengage()

func _on_emotions_area_entered(area: Area2D) -> void:
	if (current_engagement == null and area.owner is Words):
		current_engagement = area
		$Love.emitting = true

func _on_emotions_area_exited(area: Area2D) -> void:
	if (current_engagement != null and area == current_engagement):
		_disengage()

func _disengage():
	current_engagement = null
	$Love.emitting = false
