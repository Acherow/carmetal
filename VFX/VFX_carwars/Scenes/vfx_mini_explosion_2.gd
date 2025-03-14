@tool
extends Node3D

@export var play: bool=false
@onready var streaks: GPUParticles3D = $streaks
@onready var muzzle: GPUParticles3D = $muzzle
@onready var smokeball: GPUParticles3D = $smokeball

func _process(delta: float) -> void:
	if play:
		run()

func run():
	play=false
	muzzle.emitting=true
	streaks.emitting=true
	smokeball.emitting=true
