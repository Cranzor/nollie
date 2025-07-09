extends HBoxContainer

var window: Window
var mouse_inside_box: bool = false
@onready var line_edit = $LineEdit
@onready var check_box = $CheckBox
@onready var color_picker_button = $ColorPickerButton
var file_path: String
var default_song_display: SongDisplayTheme
@onready var label = $MarginContainer/Label

@export_enum("track_text_font_color", "skip_text_font_color", "track_text_shadow_color", "skip_text_shadow_color",
"track_text_shadow_size", "skip_text_shadow_size", "background_texture", "music_icon", "skip_song_icon", "background_transparency_level",
"music_icon_transparency_level", "skip_song_icon_transparency_level", "display_music_icon", "display_skip_song_icon", "display_skip_song_text",
"before_track_text_bbcode", "after_track_text_bbcode", "before_skip_text_bbcode", "after_skip_text_bbcode") var property_to_change: String

@export_enum("File Path", "Check Box", "Color", "Int", "BBCode") var theme_builder_type: int
@onready var type_and_node = {0 : line_edit, 1 : check_box, 2 : color_picker_button, 3 : line_edit, 4 : line_edit}
@onready var options = [line_edit, check_box, color_picker_button]

func _ready() -> void:
	if label.text == "Setting:":
		var new_text = property_to_change
		new_text = new_text.capitalize()
		label.text = new_text + ":"
	
	show_child_nodes(theme_builder_type)
	if theme_builder_type == 3:
		line_edit.custom_minimum_size = Vector2(25, 2)
	window = get_window()
	window.files_dropped.connect(_file_dropped)
	line_edit.mouse_entered.connect(_mouse_entered_box)
	line_edit.mouse_exited.connect(_mouse_exited_box)
	default_song_display = preload("res://themes/default_song_display.tres")
	

func _file_dropped(files: PackedStringArray) -> void:
	file_path = files[0]

func _mouse_entered_box() -> void:
	if file_path != "":
		line_edit.text = file_path

func _mouse_exited_box() -> void:
	file_path = ""

func show_child_nodes(type: int) -> void:
	if type == 1:
		check_box.show()
		line_edit.hide()
		color_picker_button.hide()
	elif type == 2:
		color_picker_button.show()
		check_box.hide()
		line_edit.hide()
