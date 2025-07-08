extends Label

var default_message = "Select a local music folder or
connect to Spotify to get started."
var local_message = "Linked with local music folder"
var spotify_message = "Connected to Spotify."

func _ready() -> void:
	if GlobalSettings.saved_local_music_folder_path != "":
		display_local_music_message()

func display_default_message() -> void:
	text = default_message

func display_local_music_message() -> void:
	var folder_path_parts = str(GlobalSettings.saved_local_music_folder_path).split("/")
	var folder_name = folder_path_parts[-1]
	text = local_message + "\n(" + folder_name + ")."

func display_spotify_message() -> void:
	text = spotify_message
