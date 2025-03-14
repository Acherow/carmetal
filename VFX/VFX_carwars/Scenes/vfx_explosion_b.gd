@tool
extends Node3D

@export var play: bool=false
@onready var ball: GPUParticles3D = $ball
@onready var little_sparks_2: GPUParticles3D = $little_sparks2
@onready var ribbon_trails_b: GPUParticles3D = $Ribbon_trails_B
@onready var sub_ribbon_trails_b: GPUParticles3D = $sub_Ribbon_trails_B
@onready var smoke: GPUParticles3D = $smoke



func _process(delta: float) -> void:
	if play:
		run()

func run():
	play=false
	ball.emitting=true
	little_sparks_2.emitting=true
	ribbon_trails_b.emitting=true
	sub_ribbon_trails_b.emitting=true
	smoke.emitting=true
