extends Node3D

@export_category("Follow Camera Settings")
# Must be a vehicle body
@export var follow_target : car
@export_range(0.0,10.0) var camera_height : float = 2.0
@export_range(1.0,20.0) var camera_distance : float = 5.0
@export_range(0.0,10.0) var rotation_damping = 1.0

@onready var anim: AnimationPlayer = $CanvasLayer/wires/lights/AnimationPlayer
@onready var label: Label = $CanvasLayer/wires/lights/Label

#locals
@onready var pivot : Node3D = $Pivot
@onready var springarm : SpringArm3D = $Pivot/SpringArm3D

@onready var nitrobar: TextureProgressBar = $CanvasLayer/TextureRect/nitrobar
@onready var healthbar: TextureProgressBar = $CanvasLayer/TextureRect/healthbar

var man : race_manager

func _ready() -> void:
	man = %racemanager
	pivot.position.y = camera_height
	springarm.spring_length = camera_distance

var died : bool = false
var ended : bool = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if(follow_target == null):
		if(!died):
			died = true
			await get_tree().create_timer(3).timeout
			print("cock")
			get_tree().change_scene_to_file('res://scenes/start.tscn')
		return
	
	if(!ended && man.endplacements.has(man.getInfo(follow_target))):
		ended = true
		anim.play("end")
		label.text = "%d PLACE" % (man.endplacements.find(man.getInfo(follow_target))+1)
	
	nitrobar.value = follow_target.boost
	healthbar.value = follow_target.health
	global_position = follow_target.global_position
	var target_horizontal_direction = follow_target.global_basis.z.slide(Vector3.UP).normalized()
	var desired_basis = Basis.looking_at(-target_horizontal_direction)
	global_basis = global_basis.slerp(desired_basis,rotation_damping*delta)
