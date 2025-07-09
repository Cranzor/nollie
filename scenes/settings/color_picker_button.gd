extends ColorPickerButton

var color_picker: ColorPicker

func _ready() -> void:
	color_picker = get_picker()
	color_picker.color_modes_visible = false
	color_picker.presets_visible = false
