extends Node

var body : car
func _ready() -> void:
	if(get_parent() is car):
		body = get_parent()
	else:
		queue_free()

func _process(delta: float) -> void:
	body.player_input.x = Input.get_axis("right","left")
	body.player_input.y = Input.get_axis("down","up")
	body.player_boost = Input.is_action_pressed("boost")
