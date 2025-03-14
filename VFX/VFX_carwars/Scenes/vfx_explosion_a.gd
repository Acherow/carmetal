@tool
extends Node3D

@export var play: bool=false
@onready var ribbon_trails: GPUParticles3D = $Ribbon_trails
@onready var muzzle: GPUParticles3D = $muzzle
@onready var ground_shockwave: GPUParticles3D = $ground_shockwave
@onready var little_sparks: GPUParticles3D = $little_sparks
@onready var debirs: GPUParticles3D = $debirs
@onready var shockwave_fc: GPUParticles3D = $shockwave_fc
@onready var ribbon_trails_c: GPUParticles3D = $Ribbon_trails_C
@onready var sub_ribbon_trails_c: GPUParticles3D = $sub_Ribbon_trails_C
@onready var smoke: GPUParticles3D = $Smoke

func _process(delta: float) -> void:
	if play:
		run()

func run():
	play=false
	ribbon_trails.emitting=true
	muzzle.emitting=true
	ground_shockwave.emitting=true
	little_sparks.emitting=true
	debirs.emitting=true
	shockwave_fc.emitting=true
	ribbon_trails_c.emitting=true
	sub_ribbon_trails_c.emitting=true
	smoke.emitting=true
