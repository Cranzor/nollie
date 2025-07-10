extends Node
@onready var main_menu = $MainMenu
@onready var music_manager = $MusicManager
@onready var previous_song_button = $MainMenu/PanelContainer/VBoxContainer/HBoxContainer/PreviousSong
@onready var play_button = $MainMenu/PanelContainer/VBoxContainer/HBoxContainer/PlayButton
@onready var next_song_button = $MainMenu/PanelContainer/VBoxContainer/HBoxContainer/NextSong
@onready var track_label = $SongDisplayWindow/SongDisplay/MarginContainer/PanelContainer/HBoxContainer/SongTitle
@onready var song_display = $SongDisplayWindow/SongDisplay
@onready var music_folder_dialog: FileDialog = $MainMenu/MusicFolderDialog
@onready var spotify_toggle = $MainMenu/PanelContainer/VBoxContainer/PanelContainer/HBoxContainer/SpotifyToggle
@onready var connection_message = $MainMenu/PanelContainer/VBoxContainer/MarginContainer2/ConnectionMessage
@onready var window = get_window()

func _ready() -> void:
	previous_song_button.pressed.connect(_previous_song_button_clicked)
	play_button.toggled.connect(_main_menu_button_clicked)
	play_button.button_down.connect(_test)
	next_song_button.pressed.connect(_next_song_button_clicked)
	music_manager.music_player.current_track_changed.connect(_current_track_changed)
	music_folder_dialog.dir_selected.connect(_music_folder_dir_selected)
	spotify_toggle.toggled.connect(_spotify_toggle)
	main_menu.settings_button_pressed.connect(_settings_button_pressed)
	main_menu.custom_theme_updated.connect(_custom_theme_updated)
	window.files_dropped.connect(_file_dropped)
	load_saved_settings()


func _main_menu_button_clicked(toggled_on: bool) -> void:
	print("hi")
	if toggled_on:
		music_manager.music_player.play()
	else:
		music_manager.music_player.pause()

func _test() -> void:
	print("clicked")

func _previous_song_button_clicked() -> void:
	music_manager.music_player.previous_track()

func _next_song_button_clicked() -> void:
	music_manager.music_player.next_track()

func _current_track_changed(track_name: String) -> void:
	if play_button.button_pressed == false:
		play_button.button_pressed = true
	song_display.update_song_title_labels(track_name)
	song_display.animation_appear(true)
	main_menu.set_song_and_artist_names(track_name)

func _music_folder_dir_selected(dir: String) -> void:
	handle_music_folder_selected(dir)

func _spotify_toggle(on: bool) -> void:
	music_manager.handle_spotify_toggle(on)
	music_manager.music_player.current_track_changed.connect(_current_track_changed)
	play_button.button_pressed = false
	if on:
		music_manager.music_player.gopotify_lost_connection.connect(_handle_lost_gopotify_connection)
		main_menu.enable_playback_buttons(true)
		connection_message.display_spotify_message()
	else:
		if !music_manager.music_player.music_directory:
			main_menu.enable_playback_buttons(false)
			connection_message.display_default_message()
		else:
			connection_message.display_local_music_message()
	main_menu.set_song_and_artist_name_visibility(false)

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
	
	if GlobalSettings.saved_local_music_folder_path != "":
		handle_music_folder_selected(GlobalSettings.saved_local_music_folder_path)

func save_local_music_folder_path(path: String):
	var settings_cfg = ConfigFile.new()
	if !FileAccess.file_exists(GlobalSettings.settings_cfg_path):
		return
	var err = settings_cfg.load(GlobalSettings.settings_cfg_path)
	if err != OK:
		return
	settings_cfg.set_value("general", "saved_local_music_folder_path", GlobalSettings.saved_local_music_folder_path)
	settings_cfg.save(GlobalSettings.settings_cfg_path)

func handle_music_folder_selected(dir: String) -> void:
	GlobalSettings.saved_local_music_folder_path = dir
	spotify_toggle.button_pressed = false
	main_menu.enable_playback_buttons(true)
	music_manager.music_player.music_directory = dir
	music_manager.music_player.initial_setup()
	connection_message.display_local_music_message()
	save_local_music_folder_path(dir)

func _settings_button_pressed():
	var settings_tabs: TabContainer = $MainMenu/Settings/Window/PanelContainer/TabContainer
	settings_tabs.tab_changed.connect(_settings_theme_builder_tab_clicked)

func _settings_theme_builder_tab_clicked(tab: int) -> void:
	var theme_builder_tab: int = 4
	if tab == theme_builder_tab:
		song_display.animation_appear(false)
	else:
		song_display.animation_disappear()

func _custom_theme_updated(custom_theme: SongDisplayTheme):
	song_display.theme = custom_theme
	song_display.song_display_theme = custom_theme
	song_display.set_up_theme()

func _file_dropped(files: PackedStringArray):
	var file: String = files[0]
	if file.get_extension() == "tres":
		_custom_theme_updated(load(file))
