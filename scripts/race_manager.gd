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
	
	
