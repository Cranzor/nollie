extends HBoxContainer

@export var default_value: String
@export var int_only_input: bool
@export var is_secret: bool
@export var max_value: int
@export var min_value: int
@export_enum("in_game_volume", "pause_volume", "spotify_client_id", "spotify_client_secret", "spotify_port") var setting_name: String

@onready var line_edit = $LineEdit
@onready var reset_settings = $ResetSettings

func _ready() -> void:
	line_edit.connect("text_submitted", _text_changed)
	line_edit.connect("editing_toggled", _line_edit_editing_toggled)
	reset_settings.connect("pressed", _reset_settings_clicked)
	set_text_field_to_global_setting()

func _text_changed(new_text: String):
	if int_only_input:
		if new_text.is_valid_int():
			var clamped_int = clamp_int_value(new_text)
			line_edit.text = clamped_int
			display_reset_settings(clamped_int)
			update_global_setting(setting_name, clamped_int)
		else:
			set_default_value(default_value)
	else:
		display_reset_settings(new_text)
		update_global_setting(setting_name, new_text)
	
	if is_secret:
		line_edit.secret = true


func display_reset_settings(new_text) -> void:
	if new_text != default_value:
		reset_settings.show()
	else:
		reset_settings.hide()

func _reset_settings_clicked() -> void:
	set_default_value(default_value)
	reset_settings.hide()

func _line_edit_editing_toggled(toggled_on: bool):
	if toggled_on == true and line_edit.secret:
		line_edit.secret = false

func set_default_value(value: String):
	line_edit.text = value
	update_global_setting(setting_name, value)

func clamp_int_value(int_value: String):
	var clamped_int = clampi(int(int_value), min_value, max_value)
	return str(clamped_int)

func update_global_setting(setting, value):
	GlobalSettings.set(setting, value)

func set_text_field_to_global_setting() -> void:
	var global_setting = str(GlobalSettings.get(setting_name))
	line_edit.text = global_setting
	display_reset_settings(global_setting)
	set_secret()

func get_setting_section_name() -> String:
	return get_parent().name.to_snake_case()

func set_secret() -> void:
	if is_secret:
		line_edit.secret = true
