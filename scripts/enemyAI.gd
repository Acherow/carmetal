extends Node

@export var avoidradius = 4

var target : Vector3
var carobj : car

func _ready() -> void:
	if(get_parent() is car):
		carobj = get_parent()
	else:
		queue_free()

func _process(delta: float) -> void:
	if(target && carobj.global_position.distance_to(target) > .1):
		carobj.player_input = GetDirection(target)
	else:
		carobj.player_input = Vector2.ZERO
	
	if(%racemanager.getInfo(carobj) != null && %racemanager.getInfo(carobj).lap <= %racemanager.maxlaps):
		target = %racemanager.checkpoints[(%racemanager.getInfo(carobj).checkpoint+1)% %racemanager.checkpoints.size()]
	else: target = Vector3.ZERO
func GetDirection(pos : Vector3) -> Vector2:
	var raydirs = []
	raydirs.resize(8)
	for i in 8:
		var angle = i * 2 * PI / 8
		raydirs[i] = Vector3.FORWARD.rotated(Vector3.UP, angle)
	var ret = Navigation.steering(raydirs, target, carobj, carobj.linear_velocity,5)
	return Vector2(ret.x,ret.y)
