extends Node
@onready var label = $Window/Canvas/Sprite2D/Control/ColorRect/ScrollContainer/Label
@onready var music_player = $MusicPlayer

func _ready() -> void:
	play_track()

func play_track():
	music_player.play()

func set_label(name):
	label.text = name


func _on_music_player_current_track_changed(passed_current_track: String) -> void:
	set_label(passed_current_track)
