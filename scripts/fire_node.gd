extends Node3D

@onready var static_flame: GPUParticles3D = $static_flame
@onready var flames: GPUParticles3D = $flames
@onready var smoke: GPUParticles3D = $smoke
@onready var particles_floating: GPUParticles3D = $particles_floating

func restart_particles():
	static_flame.restart()
	flames.restart()
	smoke.restart()
	particles_floating.restart()
