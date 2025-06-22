extends Control

@onready var play_button = %PlayButton
@onready var folder_button = %FolderButton
@onready var music_folder_dialog: FileDialog = %MusicFolderDialog

@onready var spotify_check_button = $PanelContainer/VBoxContainer/PanelContainer/HBoxContainer/SpotifyToggle
@onready var spotify_setup_message = $SpotifySetupMessage
@onready var spotify_setup_message_container = $PanelContainer/VBoxContainer/PanelContainer/HBoxContainer


func _ready() -> void:
	folder_button.button_down.connect(_folder_button_pressed)
	music_folder_dialog.dir_selected.connect(_music_folder_dir_selected)
	#---
	spotify_check_button.mouse_entered.connect(_show_spotify_setup_message)
	spotify_check_button.mouse_exited.connect(_hide_spotify_setup_message)

func _on_play_button_mouse_entered() -> void:
	play_button.self_modulate = Color(0.805, 0.805, 0.805)

func _on_play_button_mouse_exited() -> void:
	play_button.self_modulate = Color(1.0, 1.0, 1.0)

func _folder_button_pressed() -> void:
	music_folder_dialog.popup()

func _music_folder_dir_selected(dir: String) -> void:
	print(dir)

func _show_spotify_setup_message():
	if spotify_check_button.disabled:
		if !spotify_setup_message.visible:
			spotify_setup_message.position = get_local_mouse_position()
		spotify_setup_message.show()

func _hide_spotify_setup_message():
	spotify_setup_message.hide()
