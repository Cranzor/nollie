extends MusicPlayer
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
var music_directory: String
var playlist: Array[String]
var current_track_index: int = 0:
	get:
		return current_track_index
	set(value):
		if value > playlist.size() - 1:
			current_track_index = 0
			playlist = randomize_track_order(playlist)
		else:
			current_track_index = value


func play() -> void:
	emit_signal("current_track_changed", get_current_artist_and_track_name())
	set_volume(false)
	if audio_stream_player.stream_paused:
		audio_stream_player.set_stream_paused(false)
		return
	var file_path = get_full_file_path_from_track_name(playlist[current_track_index])
	if file_path.get_extension() == "wav":
		audio_stream_player.stream = AudioStreamWAV.load_from_file(file_path)
	elif file_path.get_extension() == "mp3":
		audio_stream_player.stream = AudioStreamMP3.load_from_file(file_path)
	audio_stream_player.play()
	#emit_signal("current_track_changed", get_current_artist_and_track_name())


func pause() -> void:
	if !audio_stream_player.stream_paused:
		audio_stream_player.set_stream_paused(true)
	


func stop() -> void:
	audio_stream_player.stop()


func next_track() -> void:
	current_track_index += 1
	play()


func previous_track() -> void:
	if GlobalSettings.previous_song_control_enabled:
		if current_track_index != 0:
			current_track_index -= 1
			play()


func set_volume(paused: bool) -> void:
	if paused:
		var volume = clampi(GlobalSettings.local_pause_volume, 0, 100)
		var normalized_volume: float = remap(volume, 0, 100, 0, 1)
		audio_stream_player.volume_linear = normalized_volume
	else:
		var volume = clampi(GlobalSettings.local_in_game_volume, 0, 100)
		var normalized_volume: float = remap(volume, 0, 100, 0, 1)
		audio_stream_player.volume_linear = normalized_volume


func get_current_artist_and_track_name() -> String:
	var track_path: String = playlist[current_track_index]
	var extension = "." + track_path.get_extension()
	var base_track_name = track_path.replace(extension, "")
	return base_track_name


func create_initial_playlist():
	var all_files = get_all_files_in_music_folder()


func get_all_files_in_music_folder() -> PackedStringArray:
	#return ResourceLoader.list_directory(music_directory)
	var all_files: PackedStringArray = DirAccess.get_files_at(music_directory)
	var all_files_valid: PackedStringArray
	for file in all_files:
		if file.get_extension() == "wav" or file.get_extension() == "mp3":
			all_files_valid.append(file)
	return all_files_valid


#func get_random_track_file_path() -> String:
	#var local_music_files: PackedStringArray = get_all_files_in_music_folder()
	#var local_music_files_valid: PackedStringArray
	#for file in local_music_files:
		#if file.get_extension() == "wav" or file.get_extension() == "mp3":
			#local_music_files_valid.append(file)
	#var number_of_files: int = local_music_files_valid.size()
	#var random_file = local_music_files_valid[randi_range(0, number_of_files - 1)]
	#var file_path = music_directory + random_file
	#return file_path


func randomize_track_order(music_files: PackedStringArray) -> Array[String]:
	var randomized_files: Array[String] = Array(Array(music_files.duplicate()), TYPE_STRING, "", null)
	randomized_files.shuffle()
	if !playlist.is_empty() and randomized_files.front() == playlist.back():
		var first_entry = randomized_files.front()
		var last_entry = randomized_files.back()
		randomized_files[0] = last_entry
		randomized_files[-1] = first_entry
	return randomized_files


func get_full_file_path_from_track_name(track_file_name: String):
	return music_directory + "/" + track_file_name


func initial_setup():
	var all_files: PackedStringArray = get_all_files_in_music_folder()
	if !all_files.is_empty():
		var all_files_randomized: Array[String] = randomize_track_order(all_files)
		playlist = all_files_randomized


func _on_audio_stream_player_finished() -> void:
	next_track()
