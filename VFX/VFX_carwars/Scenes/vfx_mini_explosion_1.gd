@tool
extends Node3D

@export var play: bool=false
@onready var spikes: GPUParticles3D = $spikes
@onready var streaks: GPUParticles3D = $streaks
@onready var smokeballs: GPUParticles3D = $smokeballs

func _process(delta: float) -> void:
	if play:
		run()

func run():
	play=false
	spikes.emitting=true
	streaks.emitting=true
	smokeballs.emitting=true
