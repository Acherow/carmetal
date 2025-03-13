extends Node

@export var avoidradius = 1

var target : Vector3
var carobj : car

var checkpoint : int = 0

var path

func _ready() -> void:
	if(get_parent() is car):
		carobj = get_parent()
	else:
		queue_free()
	await get_tree().process_frame
	path = get_tree().current_scene.get_node("%racemanager").checkpoints.duplicate()
	path.reverse()

func _process(delta: float) -> void:
	if(path == null): return
	
	if(target && carobj.global_position.distance_to(target) > .1):
		carobj.player_input = GetDirection(target)
		#print(carobj.player_input)
	else:
		carobj.player_input = Vector2.ZERO
	
	target = path[(checkpoint+1)%path.size()]
	if(carobj.global_position.distance_to(path[checkpoint]) > carobj.global_position.distance_to(path[(checkpoint + 1) % path.size()])):
		checkpoint = (checkpoint + 1) % path.size()
	
func GetDirection(pos : Vector3) -> Vector2:
	var raydirs = []
	raydirs.resize(8)
	for i in 8:
		var angle = i * 2 * PI / 8
		raydirs[i] = Vector3.FORWARD.rotated(Vector3.UP, angle)
	var ret = Navigation.steering(raydirs, target, carobj, carobj.linear_velocity,5)
	#print(ret)
	if(ret.z < 0):
		ret.x = -ret.x
	#return Vector2(roundi(ret.x),roundi(ret.z))
	return Vector2((ret.x),(ret.z))
