class_name PlayerModel

extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var anim_dict = {
	"cb": "raider_inplace_anim_lib_set/crouch_b",
	"cbl": "raider_inplace_anim_lib_set/crouch_bl",
	"cbr": "raider_inplace_anim_lib_set/crouch_br",
	"cf": "raider_inplace_anim_lib_set/crouch_f",
	"cfl": "raider_inplace_anim_lib_set/crouch_fl",
	"cfr": "raider_inplace_anim_lib_set/crouch_fr",
	"cl": "raider_inplace_anim_lib_set/crouch_l",
	"cr": "raider_inplace_anim_lib_set/crouch_r",
	"ci": "raider_inplace_anim_lib_set/idle_crouch",
	
	"wb": "raider_inplace_anim_lib_set/walk_b",
	"wbl": "raider_inplace_anim_lib_set/walk_bl",
	"wbr": "raider_inplace_anim_lib_set/walk_br",
	"wf": "raider_inplace_anim_lib_set/walk_f",
	"wfl": "raider_inplace_anim_lib_set/walk_fl",
	"wfr": "raider_inplace_anim_lib_set/walk_fr",
	"wl": "raider_inplace_anim_lib_set/walk_l",
	"wr": "raider_inplace_anim_lib_set/walk_r",
	
	"i": "raider_inplace_anim_lib_set/idle",
	
	"ju": "raider_inplace_anim_lib_set/ju",
	"jd": "raider_inplace_anim_lib_set/jd",
	"ji": "raider_inplace_anim_lib_set/ji"
}

func _ready() -> void:
	# comment
	pass

func play_animation(anim : String):
	animation_player.play(anim_dict[anim])
