extends RichTextLabel

var port = {"port" : 8889}

var message = "To get Spotify set up, go to [url]https://developer.spotify.com/dashboard/create[/url].
Set the app name and description to whatever you would like.
Set the redict URI to: [url]http://127.0.0.1:{port}/callback[/url] (click to copy)

After you finish, open the app and paste the Client ID and secret from the top box into the settings above.

To start playing from Spotify, open the Spotify player desktop app or open it in the browser.
Click play on a song from within the Spotify player to mark the player as active.
After that, return to the main menu and click the Spotify toggle to connect."

func _ready() -> void:
	text = message.format(port)
	self.meta_clicked.connect(_open_spotify_dashboard)
	GlobalSettings.spotify_port_changed.connect(_update_message_text)

func _open_spotify_dashboard(url: String) -> void:
	if url.begins_with("https://"):
		OS.shell_open(str(url))
	else:
		DisplayServer.clipboard_set(str(url))

func _update_message_text(new_port: String) -> void:
	port["port"] = new_port
	text = message.format(port)
