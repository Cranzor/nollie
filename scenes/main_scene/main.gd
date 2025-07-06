extends Node
@onready var main_menu = $MainMenu
@onready var music_manager = $MusicManager
@onready var play_button = $MainMenu/PanelContainer/VBoxContainer/HBoxContainer/PlayButton
@onready var track_label = $SongDisplayWindow/SongDisplay/MarginContainer/PanelContainer/HBoxContainer/SongTitle
@onready var song_display = $SongDisplayWindow/SongDisplay
@onready var music_folder_dialog: FileDialog = $MainMenu/MusicFolderDialog
@onready var spotify_toggle = $MainMenu/PanelContainer/VBoxContainer/PanelContainer/HBoxContainer/SpotifyToggle

func _ready() -> void:
	play_button.toggled.connect(_main_menu_button_clicked)
	music_manager.music_player.current_track_changed.connect(_current_track_changed)
	music_folder_dialog.dir_selected.connect(_music_folder_dir_selected)
	spotify_toggle.toggled.connect(_spotify_toggle)
	load_saved_settings()


func _main_menu_button_clicked(toggled_on: bool) -> void:
	if toggled_on:
		music_manager.music_player.play()
	else:
		music_manager.music_player.pause()

func _current_track_changed(track_name: String) -> void:
	if play_button.button_pressed == false:
		play_button.button_pressed = true
	song_display.update_song_title_labels(track_name)
	song_display.animation_appear()

func _music_folder_dir_selected(dir: String) -> void:
	main_menu.enable_playback_buttons(true)
	music_manager.music_player.music_directory = dir
	music_manager.music_player.initial_setup()

func _spotify_toggle(on: bool) -> void:
	music_manager.handle_spotify_toggle(on)
	music_manager.music_player.current_track_changed.connect(_current_track_changed)
	play_button.button_pressed = false
	if on:
		music_manager.music_player.gopotify_lost_connection.connect(_handle_lost_gopotify_connection)
		main_menu.enable_playback_buttons(true)
	else:
		if !music_manager.music_player.music_directory:
			main_menu.enable_playback_buttons(false)

func _handle_lost_gopotify_connection() -> void:
	spotify_toggle.button_pressed = false

func load_saved_settings():
	var settings_cfg = ConfigFile.new()
	var err = settings_cfg.load(GlobalSettings.settings_cfg_path)
	if err != OK:
		return
	var sections = settings_cfg.get_sections()
	for section in sections:
		var section_keys = settings_cfg.get_section_keys(section)
		for key in section_keys:
			GlobalSettings.set(key, settings_cfg.get_value(section, key))
