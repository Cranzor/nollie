extends Node
class_name MusicPlayer

signal current_track_changed(passed_current_track: String)

func play() -> void:
	pass


func pause() -> void:
	pass


func next_track() -> void:
	pass


func previous_track() -> void:
	pass


func set_volume(paused: bool) -> void:
	pass


func get_current_artist_and_track_name() -> String:
	return ""
