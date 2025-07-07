extends Node

var settings_cfg_path = "user://settings.cfg"

# volume
var in_game_volume: int = 85
var pause_volume: int = 65

# Spotify
var spotify_client_id: String:
	set(value):
		spotify_client_id = value
		emit_signal("spotify_client_id_changed", value)
var spotify_client_secret: String:
	set(value):
		spotify_client_secret = value
		emit_signal("spotify_client_secret_changed", value)
var spotify_port: String = "8889":
	set(value):
		spotify_port = value
		emit_signal("spotify_port_changed", value)
signal spotify_client_id_changed(new_client_id)
signal spotify_client_secret_changed(new_client_secret)
signal spotify_port_changed(new_port)
signal song_display_offset_changed(new_pixel_offset: int)

# controls
var previous_song_control_enabled: bool = false

# display
var song_display_pixel_offset_from_bottom: int = 10:
	set(value):
		song_display_pixel_offset_from_bottom = value
		emit_signal("song_display_offset_changed", value)
