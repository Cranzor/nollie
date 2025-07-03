extends MusicPlayer
@onready var gopotify = $Gopotify
@onready var request_timer = $RequestTimer

func _ready() -> void:
	request_timer.timeout.connect(_emit_track_changed_signal)
	GlobalSettings.spotify_client_id_changed.connect(_client_id_changed)
	GlobalSettings.spotify_client_secret_changed.connect(_client_secret_changed)
	GlobalSettings.spotify_port_changed.connect(_client_port_changed)


func play() -> void:
	gopotify.play()
	request_timer.start()
	
func next_track() -> void:
	gopotify.next()
	request_timer.start()

func previous_track() -> void:
	gopotify.previous()
	request_timer.start()

func set_volume(volume: int) -> void:
	gopotify.set_volume(volume)

func get_current_artist_and_track_name() -> String:
	return await gopotify.get_current_track()

func establish_spotify_connection() -> void:
	if gopotify.credentials == null or gopotify.credentials.is_expired():
		gopotify.request_user_authorization()
		await gopotify.server.credentials_received

func _emit_track_changed_signal():
	emit_signal("current_track_changed", await get_current_artist_and_track_name())

func _client_id_changed(new_client_id):
	gopotify.client_id = new_client_id

func _client_secret_changed(new_client_secret):
	gopotify.client_secret = new_client_secret

func _client_port_changed(new_port):
	gopotify.port = new_port
