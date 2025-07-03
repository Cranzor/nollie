extends HBoxContainer

@export var default_value: String

@onready var line_edit = $LineEdit
@onready var reset_settings = $ResetSettings

func _ready() -> void:
	set_default_value(default_value)
	line_edit.connect("text_submitted", _text_changed)
	reset_settings.connect("pressed", _reset_settings_clicked)

func _text_changed(new_text: String):
	if new_text != default_value:
		reset_settings.show()
	else:
		reset_settings.hide()

func _reset_settings_clicked() -> void:
	set_default_value(default_value)
	reset_settings.hide()

func set_default_value(value: String):
	line_edit.text = value
