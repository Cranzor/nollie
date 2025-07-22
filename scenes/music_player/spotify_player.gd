extends MusicPlayer
@onready var gopotify = $Gopotify
@onready var request_timer = $RequestTimer
@onready var track_progress = $TrackProgress
@onready var track_monitor = $TrackMonitor

signal gopotify_lost_connection
signal song_already_playing
var lost_connection: bool

func _ready() -> void:
	request_timer.timeout.connect(_emit_track_changed_signal)
	track_progress.timeout.connect(_track_progress_timeout)
	track_monitor.timeout.connect(_track_monitor_timeout)
	gopotify.lost_connection.connect(_gopotify_lost_connection)
	GlobalSettings.spotify_client_id_changed.connect(_client_id_changed)
	GlobalSettings.spotify_client_secret_changed.connect(_client_secret_changed)
	GlobalSettings.spotify_port_changed.connect(_client_port_changed)


func play() -> void:
	await get_tree().create_timer(1).timeout
	gopotify.play()
	start_request_timer()
	await get_tree().create_timer(3).timeout
	set_volume(false)
	

func pause() -> void:
	gopotify.pause()
	track_monitor.stop()


func next_track() -> void:
	gopotify.next()
	start_request_timer()

func previous_track(from_controller: bool) -> void:
	if from_controller and GlobalSettings.previous_song_control_enabled:
		gopotify.previous()
		start_request_timer()
	elif not from_controller:
		gopotify.previous()
		start_request_timer()

func set_volume(paused: bool) -> void:
	if paused:
		gopotify.set_volume(GlobalSettings.spotify_pause_volume)
	else:
		gopotify.set_volume(GlobalSettings.spotify_in_game_volume)

func establish_spotify_connection() -> void:
	if gopotify.credentials == null or gopotify.credentials.is_expired():
		gopotify.request_user_authorization()
		await gopotify.server.credentials_received
	#start_request_timer() #TODO: auto-start when song is already playing. seems like the Spotify API isn't happy with this now for some reason

func _emit_track_changed_signal():
	var is_playing: bool
	var current_track_info = await gopotify.get_current_track()
	if current_track_info != null:
		is_playing = current_track_info[3]
	if current_track_info != null and is_playing:
		emit_signal("current_track_changed", current_track_info[0])
		update_track_progress_timer(current_track_info)
	track_monitor.start()

func _track_monitor_timeout() -> void:
	var current_track_info = await gopotify.get_current_track()
	if current_track_info != null:
		update_track_progress_timer(current_track_info)

func update_track_progress_timer(current_track_info) -> void:
	var duration_in_seconds = float(current_track_info[2]) / 1000.0
	var progress_in_seconds = float(current_track_info[1]) / 1000.0
	var time_remaining = duration_in_seconds - progress_in_seconds
	track_progress.wait_time = time_remaining
	track_progress.start()

func stop_timers() -> void:
	track_progress.stop()
	track_monitor.stop()

func _client_id_changed(new_client_id):
	gopotify.client_id = new_client_id

func _client_secret_changed(new_client_secret):
	gopotify.client_secret = new_client_secret

func _client_port_changed(new_port):
	gopotify.port = new_port

func _track_progress_timeout():
	start_request_timer()

func _gopotify_lost_connection():
	stop_timers()
	emit_signal("gopotify_lost_connection")

func start_request_timer() -> void:
	request_timer.wait_time = GlobalSettings.spotify_seconds_before_song_title_displays
	request_timer.start()
