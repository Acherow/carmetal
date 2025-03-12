extends Node

@export var racers : Array[carinfo]

@export var checkpoints : Array[Node3D]

func _process(delta: float) -> void:
	var n : Node3D
	#n.global_position.distance_to()
	racers = racers.filter(func(a): return a.carobj != null)
	racers.sort_custom(func(a,b): 
		if(a.lap == b.lap):
			if(a.checkpoint == b.checkpoint):
				return a.carobj.global_position.distance_to(checkpoints[(a.checkpoint+1)%checkpoints.size()]) < b.carobj.global_position.distance_to(checkpoints[(b.checkpoint+1)%checkpoints.size()])
			else:
				return a.checkpoint < b.checkpoint
		else:
			return a.lap < b.lap
		)
func checkplacement(racer : carinfo):
	var index = 0
	var dist = 9999
	for n in checkpoints.size():
		if(racer.carobj.global_position.distance_to(checkpoints[n].global_position) < dist):
			index = n
			dist = racer.carobj.global_position.distance_to(checkpoints[n].global_position)
	if(racer.checkpoint == index - 2):
		racer.checkpointcount += 2
		racer.checkpoint = index
	elif(racer.checkpoint == index - 1):
		racer.checkpointcount += 1
		racer.checkpoint = index
	if(index == 0 && racer.checkpointcount + 1 >= checkpoints.size()):
		racer.lap += 1
		racer.checkpointcount = 0
		racer.checkpoint = 0
	return [index, dist]
