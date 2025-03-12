extends Node

@export var avoidradius = 4

var target : Node3D
var carobj : car

func _ready() -> void:
	if(get_parent() is car):
		carobj = get_parent()
	else:
		queue_free()

func _process(delta: float) -> void:
	if(target && carobj.global_position.distance_to(target.global_position) > .1):
		carobj.player_input = GetDirection(target.global_position)

func GetDirection(pos : Vector3) -> Vector2:
	var ret = Vector2.ZERO
	return ret
