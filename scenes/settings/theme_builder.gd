extends ScrollContainer

@onready var default_song_display: SongDisplayTheme = preload("res://themes/default_song_display.tres")
signal custom_theme_updated(custom_theme: SongDisplayTheme)

func _ready() -> void:
	connect_to_all_theme_builder_inputs()
	
func connect_to_all_theme_builder_inputs():
	var vbox = $VBoxContainer
	var theme_builder_inputs = vbox.get_children()
	for child in theme_builder_inputs:
		if child.is_in_group("theme_builder_input"):
			child.theme_value_updated.connect(_theme_value_updated)

func _theme_value_updated(property: String, value: Variant):
	default_song_display.set(property, value)
	emit_signal("custom_theme_updated", default_song_display)
