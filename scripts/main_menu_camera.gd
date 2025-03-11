extends Camera3D

var xNoise: FastNoiseLite
var yNoise: FastNoiseLite

var targetRot = Vector3()
var eventRot = Vector2()
var noiseRot = Vector3()
var noiseCount = 0
@export var noiseAmp: float = 6.0
@export var noiseFreq: float = 10.0

func _ready() -> void:
	xNoise = FastNoiseLite.new()
	yNoise = FastNoiseLite.new()
	xNoise.seed = 0
	xNoise.fractal_octaves = 1
	yNoise.seed = 1
	yNoise.fractal_octaves = 1

func _physics_process(delta: float) -> void:
	noiseCount += delta * noiseFreq
	noiseRot.x = xNoise.get_noise_1d(noiseCount) * noiseAmp
	noiseRot.y = yNoise.get_noise_1d(noiseCount) * noiseAmp
	targetRot.x += eventRot.x
	targetRot.y += eventRot.y
	eventRot = Vector2.ZERO
	rotation_degrees = targetRot + noiseRot
