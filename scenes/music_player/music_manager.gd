extends Node

var music_player: MusicPlayer
@onready var local_player = $LocalPlayer
@onready var spotify_player = $SpotifyPlayer
var using_spotify: bool = false

@onready var game_state_tracker = $GameStateTracker

func _ready() -> void:
	AudioServer.set_bus_volume_db(0, -12.0)
	if using_spotify:
		music_player = spotify_player
	else:
		music_player = local_player
		
	GlobalSettings.volume_changed.connect(_global_settings_volume_changed)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("next_song"):
		music_player.next_track()
	elif Input.is_action_just_pressed("previous_song"):
		music_player.previous_track(true)


func _on_game_state_tracker_pause_status_changed(paused_status: Variant) -> void:
	if paused_status:
		music_player.set_volume(true)
	else:
		music_player.set_volume(false)

func handle_spotify_toggle(on: bool):
	if on:
		music_player.stop()
		music_player = spotify_player
		music_player.establish_spotify_connection()
	else:
		music_player.stop_timers()
		music_player = local_player

func _global_settings_volume_changed(paused: bool):
	_on_game_state_tracker_pause_status_changed(paused)
