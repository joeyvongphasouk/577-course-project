extends TextureButton

var locked_levels = ["level_two", "level_three","level_four"]

func _ready() -> void:
	set_ignore_texture_size(true)
	set_stretch_mode(STRETCH_KEEP_ASPECT_COVERED)

	if get_parent().name in locked_levels:
		modulate = Color(0.2, 0.2, 0.2, 1.0)
