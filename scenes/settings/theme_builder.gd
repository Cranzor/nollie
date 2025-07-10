extends ScrollContainer

@onready var default_song_display: SongDisplayTheme = preload("res://themes/default_song_display.tres")
@onready var window: Window = get_window()
var current_file_path: String
signal custom_theme_updated(custom_theme: SongDisplayTheme)

func _ready() -> void:
	connect_to_all_theme_builder_inputs()
	window.files_dropped.connect(_file_dropped)
	
func connect_to_all_theme_builder_inputs():
	var vbox = $VBoxContainer
	var theme_builder_inputs = vbox.get_children()
	for child in theme_builder_inputs:
		if child.is_in_group("theme_builder_input"):
			child.theme_value_updated.connect(_theme_value_updated)
			child.file_path_entered.connect(_file_path_entered)

func _theme_value_updated(property: String, value: Variant):
	default_song_display.set(property, value)
	emit_signal("custom_theme_updated", default_song_display)

func _file_dropped(files: PackedStringArray):
	current_file_path = files[0]

func _file_path_entered() -> void:
	current_file_path = ""
