extends Node

func basis_rotate_toward(originBasis, targetBasis, amount):
	var originRot = originBasis.get_rotation_quaternion()
	var targetRot : Quaternion = targetBasis.get_rotation_quaternion()
	targetRot.z = originRot.z
	targetRot = targetRot.normalized()
	var returnRot = originRot.slerp(targetRot, min(1.0, amount / originRot.angle_to(targetRot)))
	return Basis(returnRot)

func _get_interest(target, origin, raydirs) -> Array:
	var interest = []
	interest.resize(raydirs.size())
	var targetdir = (target.transform.origin - origin.transform.origin).normalized()
	for i in raydirs.size():
		var d = raydirs[i].rotated(Vector3.UP, origin.rotation.y).dot(targetdir)
		interest[i] = max(0, d)
	return interest

func _get_danger(target, origin, originoffset, range, raydirs) -> Array:
	var danger = []
	danger.resize(raydirs.size())
	var space = origin.get_world_3d().direct_space_state
	for i in raydirs.size():
		var params = PhysicsRayQueryParameters3D.create(origin.position + originoffset, 
		origin.position + originoffset + raydirs[i].rotated(Vector3.UP, origin.rotation.y) * range, 0xFFFFFFFF, [origin, target])
		var result = space.intersect_ray(params)
		if(result):
			danger[i] = 1 - clampf(origin.position.distance_to(result.position) / range, 0.0, 1.0)
		else:
			params = PhysicsRayQueryParameters3D.create(origin.position + originoffset + 
			raydirs[i].rotated(Vector3.UP, origin.rotation.y) * (range/2), origin.position + raydirs[i].rotated(Vector3.UP, origin.rotation.y) * (range/2) + Vector3.DOWN * (range * 2), 0xFFFFFFFF, [origin, target])
			result = space.intersect_ray(params)
			if(!result):
				danger[i] = 1
			else:
				danger[i] = 0
	return danger

func steering(raydirs, target, origin, originoffset, range):
	var danger = _get_danger(target,origin,originoffset, range, raydirs)
	var interest = _get_interest(target,origin, raydirs)
	for i in raydirs.size():
		if(danger[i] > 0):
			interest[i] -= danger[i]
		interest[i] = clampf(interest[i], 0, 1)
	var chosen_dir = Vector3.ZERO
	for i in raydirs.size():
		chosen_dir += raydirs[i] * interest[i]
	chosen_dir = chosen_dir.normalized()
	return chosen_dir
