extends Control

@onready var play_button = %PlayButton
@onready var folder_button = %FolderButton
@onready var music_folder_dialog: FileDialog = %MusicFolderDialog
@onready var settings = %Settings
@onready var previous_song = %PreviousSong
@onready var next_song = %NextSong
@onready var song_and_artist = $PanelContainer/VBoxContainer/SongAndArtist
@onready var song_title = $PanelContainer/VBoxContainer/SongAndArtist/Song
@onready var artist_name = $PanelContainer/VBoxContainer/SongAndArtist/Artist
var settings_window: Control

@onready var spotify_check_button = $PanelContainer/VBoxContainer/PanelContainer/HBoxContainer/SpotifyToggle
@onready var spotify_setup_message = $SpotifySetupMessage
@onready var spotify_setup_message_container = $PanelContainer/VBoxContainer/PanelContainer/HBoxContainer

signal settings_button_pressed
signal settings_window_closed
signal custom_theme_updated(custom_theme: SongDisplayTheme)

func _ready() -> void:
	folder_button.pressed.connect(_folder_button_pressed)
	music_folder_dialog.dir_selected.connect(_music_folder_dir_selected)
	settings.button_down.connect(_settings_button_pressed)
	#---
	spotify_check_button.mouse_entered.connect(_show_spotify_setup_message)
	spotify_check_button.mouse_exited.connect(_hide_spotify_setup_message)
	check_spotify_settings()
	GlobalSettings.spotify_client_id_changed.connect(_spotify_value_changed)
	GlobalSettings.spotify_client_secret_changed.connect(_spotify_value_changed)

func enable_playback_buttons(enable: bool):
	var playback_buttons = [previous_song, play_button, next_song]
	for button in playback_buttons:
		if enable:
			button.disabled = false
			button.reset_button_color()
		else:
			button.darken_button_color()
			button.disabled = true

func _on_play_button_mouse_entered() -> void:
	play_button.self_modulate = Color(0.805, 0.805, 0.805)

func _on_play_button_mouse_exited() -> void:
	play_button.self_modulate = Color(1.0, 1.0, 1.0)

func _folder_button_pressed() -> void:
	if music_folder_dialog.transient:
		music_folder_dialog.popup()

func _music_folder_dir_selected(dir: String) -> void:
	pass

func _show_spotify_setup_message():
	if spotify_check_button.disabled:
		if !spotify_setup_message.visible:
			spotify_setup_message.position = get_local_mouse_position() - Vector2(100, 0)
		spotify_setup_message.show()

func _hide_spotify_setup_message():
	spotify_setup_message.hide()

func _settings_button_pressed() -> void:
	if !is_instance_valid(settings_window):
		var settings_window_node = preload("res://scenes/settings/settings.tscn").instantiate()
		settings_window_node.name = "Settings"
		add_child(settings_window_node)
		emit_signal("settings_button_pressed")
		settings_window_node.custom_theme_updated.connect(_custom_theme_updated)
		settings_window_node.settings_closed.connect(_settings_window_closed)

func check_spotify_settings() -> void:
	if GlobalSettings.spotify_client_id == "" or GlobalSettings.spotify_client_secret == "":
		spotify_check_button.disabled = true
	else:
		spotify_check_button.disabled = false

func _spotify_value_changed(value: String) -> void:
	check_spotify_settings()

func set_song_and_artist_names(track: String) -> void:
	#TODO: update this to handle songs that have " - " in the title better
	var delimiter = " - "
	if track.contains(delimiter):
		set_song_and_artist_name_visibility(true)
		var artist_and_song = track.split(" - ")
		var artist = artist_and_song[0]
		var song = artist_and_song[1]
		song_title.text = song
		artist_name.text = artist
	else:
		set_song_and_artist_name_visibility(false)

func set_song_and_artist_name_visibility(show: bool) -> void:
	if show:
		song_and_artist.show()
	else:
		song_and_artist.hide()

func _custom_theme_updated(custom_theme: SongDisplayTheme):
	emit_signal("custom_theme_updated", custom_theme)

func _settings_window_closed() -> void:
	emit_signal("settings_window_closed")
