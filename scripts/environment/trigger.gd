class_name trigger extends Node3D
@export var open: bool = false
@export var indicators: Array[Node]

signal trigger_change

func _turn_on():
	emit_signal("trigger_change")
	print("on")
	for obj in indicators:
		if obj.has_method("_trigger_on"):
			obj._trigger_on()
	pass

func _turn_off():
	print("offf")
	emit_signal("trigger_change")
	for obj in indicators:
		if obj.has_method("_trigger_off"):
			obj._trigger_off()
	pass
