extends ScrollContainer

@onready var default_song_display: SongDisplayTheme = preload("res://themes/default_song_display.tres")
@onready var new_song_display: SongDisplayTheme
@onready var window: Window = get_window()
@onready var reset_button: Button = $VBoxContainer/ResetToDefault
@onready var save_button: Button = $VBoxContainer/SaveTheme
@onready var file_dialog: FileDialog = $FileDialog
var current_file_path: String
signal custom_theme_updated(custom_theme: SongDisplayTheme)

func _ready() -> void:
	connect_to_all_theme_builder_inputs()
	new_song_display = default_song_display.duplicate()
	window.files_dropped.connect(_file_dropped)
	reset_button.pressed.connect(_reset_theme)
	save_button.pressed.connect(_save_theme)
	file_dialog.file_selected.connect(_file_dialog_file_selected)
	
func connect_to_all_theme_builder_inputs():
	var vbox = $VBoxContainer
	var theme_builder_inputs = vbox.get_children()
	for child in theme_builder_inputs:
		if child.is_in_group("theme_builder_input"):
			child.theme_value_updated.connect(_theme_value_updated)
			child.file_path_entered.connect(_file_path_entered)

func _theme_value_updated(property: String, value: Variant):
	new_song_display.set(property, value)
	emit_signal("custom_theme_updated", new_song_display)

func _file_dropped(files: PackedStringArray):
	current_file_path = files[0]

func _file_path_entered() -> void:
	current_file_path = ""

func _reset_theme() -> void:
	new_song_display = default_song_display.duplicate()
	emit_signal("custom_theme_updated", default_song_display)
	get_tree().call_group("theme_builder_input", "reset_values")

func _save_theme() -> void:
	if file_dialog.transient:
		file_dialog.popup()
	
func _file_dialog_file_selected(path: String):
	ResourceSaver.save(new_song_display, path + ".tres")
