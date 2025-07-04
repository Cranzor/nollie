extends MusicPlayer
@onready var gopotify = $Gopotify
@onready var request_timer = $RequestTimer
@onready var track_progress = $TrackProgress
@onready var track_monitor = $TrackMonitor

func _ready() -> void:
	request_timer.timeout.connect(_emit_track_changed_signal)
	track_progress.timeout.connect(_track_progress_timeout)
	track_monitor.timeout.connect(_track_monitor_timeout)
	GlobalSettings.spotify_client_id_changed.connect(_client_id_changed)
	GlobalSettings.spotify_client_secret_changed.connect(_client_secret_changed)
	GlobalSettings.spotify_port_changed.connect(_client_port_changed)


func play() -> void:
	gopotify.play()
	request_timer.start()
	track_monitor.start()
	

func pause() -> void:
	gopotify.pause()
	track_monitor.stop()


func next_track() -> void:
	gopotify.next()
	request_timer.start()

func previous_track() -> void:
	gopotify.previous()
	request_timer.start()

func set_volume(volume: int) -> void:
	gopotify.set_volume(volume)

func establish_spotify_connection() -> void:
	if gopotify.credentials == null or gopotify.credentials.is_expired():
		gopotify.request_user_authorization()
		await gopotify.server.credentials_received

func _emit_track_changed_signal():
	var current_track_info = await gopotify.get_current_track()
	emit_signal("current_track_changed", current_track_info[0])
	update_track_progress_timer(current_track_info)

func _track_monitor_timeout() -> void:
	var current_track_info = await gopotify.get_current_track()
	update_track_progress_timer(current_track_info)

func update_track_progress_timer(current_track_info) -> void:
	var duration_in_seconds = float(current_track_info[2]) / 1000.0
	var progress_in_seconds = float(current_track_info[1]) / 1000.0
	var time_remaining = duration_in_seconds - progress_in_seconds
	track_progress.wait_time = time_remaining
	track_progress.start()

func _client_id_changed(new_client_id):
	gopotify.client_id = new_client_id

func _client_secret_changed(new_client_secret):
	gopotify.client_secret = new_client_secret

func _client_port_changed(new_port):
	gopotify.port = new_port

func _track_progress_timeout():
	request_timer.start()
