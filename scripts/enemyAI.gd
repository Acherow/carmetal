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
	var raydirs = []
	for i in 8:
		var angle = i * 2 * PI / 8
		raydirs[i] = Vector3.FORWARD.rotated(Vector3.UP, angle)
	var ret = Navigation.steering(raydirs, target, carobj, carobj.linear_velocity,5)
	return ret
