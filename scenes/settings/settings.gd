extends Control

@onready var window = $Window
@onready var settings_cfg = ConfigFile.new()

@onready var in_game_volume_field = $Window/PanelContainer/TabContainer/Sound/InGameVolume/LineEdit
@onready var pause_volume_field = $Window/PanelContainer/TabContainer/Sound/PauseVolume/LineEdit
@onready var spotify_client_id_field = $Window/PanelContainer/TabContainer/Spotify/ClientID/LineEdit
@onready var spotify_client_secret_field = $Window/PanelContainer/TabContainer/Spotify/ClientSecret/LineEdit
@onready var spotify_client_port_field = $Window/PanelContainer/TabContainer/Spotify/Port/LineEdit
@onready var theme_builder_tab = $"Window/PanelContainer/TabContainer/Theme Builder"
@onready var tab_container: TabContainer = $Window/PanelContainer/TabContainer
@onready var theme_builder: ScrollContainer
signal custom_theme_updated(custom_theme: SongDisplayTheme)
signal settings_closed

func _ready() -> void:
	settings_cfg = ConfigFile.new()
	if !FileAccess.file_exists(GlobalSettings.settings_cfg_path):
		set_cfg_file_values(settings_cfg)
	var err = settings_cfg.load(GlobalSettings.settings_cfg_path)
	if err != OK:
		return
	
	tab_container.tab_changed.connect(_tab_container_tab_changed)
	#settings_cfg.clear()
	#settings_cfg.save(GlobalSettings.settings_cfg_path)

func make_window_visible() -> void:
	$Window.popup()

func _on_window_close_requested() -> void:
	set_cfg_file_values(settings_cfg)
	emit_signal("settings_closed")
	self.queue_free()

func set_cfg_file_values(cfg_file: ConfigFile):
	var tab_container = $Window/PanelContainer/TabContainer
	var sections = tab_container.get_children()
	for section in sections:
		var options = section.get_children()
		for option in options:
			if option.is_in_group("option"):
				cfg_file.set_value(section.name.to_snake_case(), option.setting_name, GlobalSettings.get(option.setting_name))
	cfg_file.save(GlobalSettings.settings_cfg_path)

func _tab_container_tab_changed(tab: int) -> void:
	if tab == 4 and !is_instance_valid(theme_builder):
		theme_builder = preload("res://scenes/settings/theme_builder.tscn").instantiate()
		theme_builder_tab.add_child(theme_builder)
		var theme_builder_node = theme_builder_tab.get_child(0)
		theme_builder_node.custom_theme_updated.connect(_custom_theme_updated)

func _custom_theme_updated(custom_theme: SongDisplayTheme):
	emit_signal("custom_theme_updated", custom_theme)
