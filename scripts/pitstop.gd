extends Node3D
@onready var timer: Timer = $Timer
signal heal(value:int)
@onready var collision_shape_3d: CollisionShape3D = $Area3D/CollisionShape3D

var cc

func _on_area_3d_body_entered(body):
	if body is car:
		$Timer.start()
		cc = body


func _on_timer_timeout() -> void:
	if cc != null:
		cc.health += 1
	else:
		$Timer.stop()


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body == cc:
		cc = null
