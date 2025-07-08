extends Label

var default_message = "Select a local music folder or
connect to Spotify to get started."
var local_message = "Linked with local music folder."
var spotify_message = "Connected to Spotify."

func display_default_message() -> void:
	text = default_message

func display_local_music_message() -> void:
	text = local_message

func display_spotify_message() -> void:
	text = spotify_message
