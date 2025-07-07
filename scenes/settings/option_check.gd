extends Option

@onready var default_check_state: bool = false
@onready var check_box: CheckBox = $CheckBox
@onready var reset_settings: TextureButton = $ResetSettings

func _ready() -> void:
	default_check_state = check_box.button_pressed
	set_check_to_global_setting()
	
	check_box.connect("toggled", _check_box_toggled)
	reset_settings.connect("pressed", _reset_settings_clicked)

func _reset_settings_clicked() -> void:
	set_default_value()

func _check_box_toggled(toggled_on: bool) -> void:
	update_global_setting(setting_name, toggled_on)
	display_reset_settings(toggled_on)

func set_default_value() -> void:
	check_box.button_pressed = default_check_state
	reset_settings.hide()

func set_check_to_global_setting() -> void:
	var global_setting = GlobalSettings.get(setting_name)
	check_box.button_pressed = global_setting
	display_reset_settings(global_setting)

func display_reset_settings(display: bool) -> void:
	if display != default_check_state:
		reset_settings.show()
	else:
		reset_settings.hide()
