@tool
extends Node3D

@export var play: bool=false
@onready var streaks: GPUParticles3D = $streaks
@onready var smokeballs: GPUParticles3D = $smokeballs
@onready var soil_sparks: GPUParticles3D = $soil_sparks
@onready var muzzle: GPUParticles3D = $muzzle


func _process(delta: float) -> void:
	if play:
		run()

func run():
	play=false
	streaks.emitting=true
	smokeballs.emitting=true
	soil_sparks.emitting=true
	muzzle.emitting=true
