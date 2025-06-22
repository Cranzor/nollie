extends AudioStreamPlayer

var test_folder: String = "res://test_music/"
var current_track: String


func get_all_files_in_music_folder() -> PackedStringArray:
	return ResourceLoader.list_directory(test_folder)

func get_random_track_file_path() -> String:
	var local_music_files: PackedStringArray = get_all_files_in_music_folder()
	var number_of_files: int = local_music_files.size()
	var random_file = local_music_files[randi_range(0, number_of_files - 1)]
	var file_path = test_folder + random_file
	return file_path

func play_random_track():
	var random_track = get_random_track_file_path()
	stream = load(random_track)
	play()
	volume_linear = 0.3
	get_parent().current_track = stream.resource_path.get_file().get_basename()
