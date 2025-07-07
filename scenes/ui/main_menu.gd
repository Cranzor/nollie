extends Control

@onready var play_button = %PlayButton
@onready var folder_button = %FolderButton
@onready var music_folder_dialog: FileDialog = %MusicFolderDialog
@onready var settings = %Settings
@onready var previous_song = %PreviousSong
@onready var next_song = %NextSong
var settings_window: Control

@onready var spotify_check_button = $PanelContainer/VBoxContainer/PanelContainer/HBoxContainer/SpotifyToggle
@onready var spotify_setup_message = $SpotifySetupMessage
@onready var spotify_setup_message_container = $PanelContainer/VBoxContainer/PanelContainer/HBoxContainer

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
			button.disabled = true

func _on_play_button_mouse_entered() -> void:
	play_button.self_modulate = Color(0.805, 0.805, 0.805)

func _on_play_button_mouse_exited() -> void:
	play_button.self_modulate = Color(1.0, 1.0, 1.0)

func _folder_button_pressed() -> void:
	if music_folder_dialog.transient:
		music_folder_dialog.popup()

func _music_folder_dir_selected(dir: String) -> void:
	print(dir)

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
		add_child(settings_window_node)

func check_spotify_settings() -> void:
	if GlobalSettings.spotify_client_id == "" or GlobalSettings.spotify_client_secret == "":
		spotify_check_button.disabled = true
	else:
		spotify_check_button.disabled = false

func _spotify_value_changed(value: String) -> void:
	check_spotify_settings()
