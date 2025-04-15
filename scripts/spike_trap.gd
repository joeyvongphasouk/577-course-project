extends Node3D

@export var trap_trigger: Node
@onready var cooldown_timer: Timer = $CooldownTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	if trap_trigger:
		trap_trigger.trap_triggered.connect(_extend)

func _extend() -> void:
	print("extending spikes")
	animation_player.play("Spikes")
	cooldown_timer.start()
	
# retract spikes when timer ends
func _on_cooldown_timer_timeout() -> void:
	animation_player.play_backwards("Spikes")
	cooldown_timer.stop()
