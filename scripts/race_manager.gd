extends Node

@export var maxlaps : int = 3

@export var racers : Array[carinfo]
@export var allracers : Array[carinfo]
@export var endplacements : Array[carinfo]

@export var checkpoints : Array[PackedVector3Array]
@export var path : Path3D

func _ready() -> void:
	checkpoints = path.curve.get_baked_points()

func _process(delta: float) -> void:
	racers = racers.filter(func(a): return a.carobj != null)
	racers.sort_custom(func(a,b): 
		if(a.lap == b.lap):
			if(a.checkpoint == b.checkpoint):
				return a.carobj.global_position.distance_to(checkpoints[(a.checkpoint+1)%checkpoints.size()]) < b.carobj.global_position.distance_to(checkpoints[(b.checkpoint+1)%checkpoints.size()])
			else:
				return a.checkpoint < b.checkpoint
		else:
			return a.lap < b.lap)
	
	for n in racers.size():
		checkplacement(racers[n])
		if(racers[n].lap > maxlaps):
			endplacements.append(racers[n])
	racers.filter(func(a): return !endplacements.has(a))
	allracers.clear()
	allracers.append_array(endplacements)
	allracers.append_array(racers)

func startrace():
	for n in racers:
		n.carobj.on = true

func checkplacement(racer : carinfo):
	var index = 0
	var dist = 9999
	for n in checkpoints.size():
		var v = checkpoints[n]
		if(racer.carobj.global_position.distance_to(v) < dist):
			index = n
			dist = racer.carobj.global_position.distance_to(v)
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

func getInfo(obj : Node3D) -> carinfo:
	for n in allracers:
		if(n.carobj == obj):
			return n
	return null
