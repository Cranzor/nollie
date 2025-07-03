extends Control

@onready var window = $Window
@onready var settings_cfg = ConfigFile.new()

@onready var in_game_volume_field = $Window/PanelContainer/TabContainer/Sound/InGameVolume/LineEdit
@onready var pause_volume_field = $Window/PanelContainer/TabContainer/Sound/PauseVolume/LineEdit
@onready var spotify_client_id_field = $Window/PanelContainer/TabContainer/Spotify/ClientID/LineEdit
@onready var spotify_client_secret_field = $Window/PanelContainer/TabContainer/Spotify/ClientSecret/LineEdit
@onready var spotify_client_port_field = $Window/PanelContainer/TabContainer/Spotify/Port/LineEdit

func _ready() -> void:
	settings_cfg = ConfigFile.new()
	if !FileAccess.file_exists(GlobalSettings.settings_cfg_path):
		set_cfg_file_values(settings_cfg)
	var err = settings_cfg.load(GlobalSettings.settings_cfg_path)
	if err != OK:
		return
	#settings_cfg.clear()
	#settings_cfg.save(GlobalSettings.settings_cfg_path)
	#update_settings_with_global_settings()
	

func make_window_visible() -> void:
	$Window.popup()

func _on_window_close_requested() -> void:
	set_cfg_file_values(settings_cfg)
	self.queue_free()


func set_cfg_file_values(cfg_file: ConfigFile):
	var tab_container = $Window/PanelContainer/TabContainer
	var sections = tab_container.get_children()
	for section in sections:
		var options = section.get_children()
		for option in options:
			cfg_file.set_value(section.name.to_snake_case(), option.setting_name, GlobalSettings.get(option.setting_name))
	cfg_file.save(GlobalSettings.settings_cfg_path)

#func update_settings_with_global_settings() -> void:
	#var tab_container = $Window/PanelContainer/TabContainer
	#var sections = tab_container.get_children()
	#for section in sections:
		#var options = section.get_children()
		#for option in options:
			#var line_edit = option.get_node_or_null("LineEdit")
			#if line_edit != null:
				#line_edit.text = str(GlobalSettings.get(option.setting_name))
	#GlobalSettings.in_game_volume = cfg_file.get_value("volume", "in_game_volume")
	#in_game_volume_field.text = GlobalSettings.in_game_volume
#
	#GlobalSettings.pause_volume = cfg_file.get_value("volume", "pause_volume")
	#pause_volume_field.text = GlobalSettings.pause_volume
	#
	#GlobalSettings.spotify_client_id = cfg_file.get_value("spotify", "spotify_client_id")
	#spotify_client_id_field.text = GlobalSettings.spotify_client_id
	#
	#GlobalSettings.spotify_client_secret = cfg_file.get_value("spotify", "spotify_client_secret")
	#spotify_client_secret_field.text = GlobalSettings.spotify_client_secret
	#
	#GlobalSettings.spotify_port = cfg_file.get_value("spotify", "spotify_port")
	#spotify_client_port_field.text = GlobalSettings.spotify_client_port
