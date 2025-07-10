extends HBoxContainer

var window: Window
var mouse_inside_box: bool = false
@onready var line_edit = $LineEdit
@onready var check_box = $CheckBox
@onready var color_picker_button = $ColorPickerButton
var file_path: String
@onready var label = $MarginContainer/Label

@export_enum("font", "track_text_font_color", "skip_text_font_color", "track_text_shadow_color", "skip_text_shadow_color",
"track_text_shadow_size", "skip_text_shadow_size", "background_texture", "music_icon", "skip_song_icon", "background_base_color", "background_modulation",
"music_icon_modulation", "skip_song_icon_modulation", "display_music_icon", "display_skip_song_icon", "display_skip_song_text",
"before_track_text_bbcode", "after_track_text_bbcode", "before_skip_text_bbcode", "after_skip_text_bbcode") var property_to_change: String

@export_enum("File Path", "Check Box", "Color", "Int", "BBCode") var theme_builder_type: int
@export_enum("None", "Image", "Font") var file_type: int
@onready var type_and_node = {0 : line_edit, 1 : check_box, 2 : color_picker_button, 3 : line_edit, 4 : line_edit}
@onready var options = [line_edit, check_box, color_picker_button]

signal theme_value_updated(property, value)
signal file_path_entered

func _ready() -> void:
	if label.text == "Setting:":
		var new_text = property_to_change
		new_text = new_text.capitalize()
		label.text = new_text + ":"
	
	show_child_nodes(theme_builder_type)
	if theme_builder_type == 3:
		line_edit.custom_minimum_size = Vector2(25, 2)

	line_edit.mouse_entered.connect(_mouse_entered_box)
	line_edit.text_submitted.connect(_line_edit_text_submitted)
	check_box.toggled.connect(_check_box_toggled)
	color_picker_button.color_changed.connect(_color_changed)


func _mouse_entered_box() -> void:
	var current_file_path: String = get_parent().get_parent().current_file_path
	if current_file_path != "":
		line_edit.text = current_file_path
		emit_signal("file_path_entered")
		_line_edit_text_submitted(current_file_path)

func show_child_nodes(type: int) -> void:
	if type == 1:
		check_box.show()
		line_edit.hide()
		color_picker_button.hide()
	elif type == 2:
		color_picker_button.show()
		check_box.hide()
		line_edit.hide()

func _line_edit_text_submitted(new_text: String):
	var value: Variant = new_text
	if theme_builder_type == 0:
		if FileAccess.file_exists(new_text):
			# handle images
			if file_type == 1:
				var image: Image = Image.new()
				image.load(new_text)
				var image_texture = ImageTexture.new()
				image_texture.set_image(image)
				value = image_texture
			# handle font files
			elif file_type == 2:
				var font = FontFile.new()
				var error = font.load_dynamic_font(new_text)
				value = font
	emit_signal("theme_value_updated", property_to_change, value)

func _check_box_toggled(toggled_on: bool):
	emit_signal("theme_value_updated", property_to_change, toggled_on)

func _color_changed(color: Color):
	emit_signal("theme_value_updated", property_to_change, color)
