extends HBoxContainer
class_name Option

@export var max_value: int
@export var min_value: int
@export_enum("local_in_game_volume", "local_pause_volume", "spotify_in_game_volume", "spotify_pause_volume", "spotify_client_id", "spotify_client_secret", 
"spotify_port", "previous_song_control_enabled", "song_display_pixel_offset_from_bottom", "applied_theme_path",
"song_display_seconds_on_screen") var setting_name: String

func update_global_setting(setting, value):
	GlobalSettings.set(setting, value)
