# Nollie Player

Nollie Player is a music player and overlay that allows you to control your music library with a controller, even while playing a game. When the song changes, a song title display appears on-screen to notify you.

## Features

Nollie allows for playback from local music files and from Spotify.

### Local Music Playback

Set up a folder with WAV or MP3 files, and name each file in "Artist - Song" format. Then, select the folder from within Nollie and press play.

### Spotify Playback

You will have to log in to your Spotify Dashboard and set things up from there. Full instructions are provided in the settings menu under the Spotify tab.
1. Go to https://developer.spotify.com/dashboard/create
2. Set the app name and description to whatever you would like
3. Set the redirect URI to: http://127.0.0.1:8889/callback (change 8889 to a different port if you change it)
4. Open the app in your dashboard and paste the Client ID and secret from the top box into Nollie's settings in the Spotify tab

### Automatic Volume Adjustment

Nollie will lower the volume automatically when you pause and bring it back up when you're back in-game.

You can also set the in-game and pause volume levels in the settings.

Note that the context it looks at to determine if you're back in-game (if you didn't unpause with the pause button) is currently tuned for the Tony Hawk games. It may not work correctly for all games at the moment. If you notice issues, you can set the in-game and pause volumes to the same level so that the value doesn't change.

## How to Use

Open Nollie on the same monitor you will play your game on.

Once you set up local or Spotify music playback, press the play button or R3 (right stick press) on your controller. (You can also set up playing the previous song with L3 in the settings.)

In the game you are playing, turn your music volume down all the way. To make sure things display correctly while you're in-game, **set the game graphics settings to be borderless fullscreen.**

For the THPS games, make sure to also go to Options -> Gameplay Options -> Song Notification and turn it off.

Note: If you are using Steam, open your game first before opening Nollie. For some reason, Steam doesn't seem to respond correctly when Nollie is open.

## Themes

If you would like to change the appearance of the song display, you can make your own theme or use a theme created by someone else.
With a different theme, you can change things like the background image and font or even add text effects.
Drag and drop a theme file onto the application and it will automatically apply.

## Steam Deck Support

Nollie does work on the Steam Deck, but requires a workaround due to how SteamOS handles displaying games. Note that the skip/previous song controller inputs won't work until you are in-game.

1. Boot into desktop mode
2. In desktop mode, go to Settings -> Keyboard -> Shortcuts -> Kwin and set a shortcut for Make Window Fullscreen
3. In desktop mode, open Steam and then open the game you would like to play, then set the graphics setting to windowed mode
4. Open Nollie
5. Open the game again in desktop mode and use the shortcut you set up to make it fullscreen

If you accidentally boot the game with the wrong settings and a black screen appears, hold Steam + B to force close the game.

## Credits
Nollie was made in Godot 4.4.1 (Mono version) and makes use of the following plugins/projects.
* [Gopotify plugin](https://github.com/drarbego/gopotify) (and [this fork updating it to Godot 4](https://github.com/EnjoyYourBan/gopotify))
* [Godot-GlobalInput-Addon](https://github.com/Darnoman/Godot-GlobalInput-Addon)
* [Godot Click Through Transparent Window](https://github.com/atadenizoktay/godot-click-through-transparent-window)

Default song display font is [Titillium Web](https://fonts.google.com/specimen/Titillium+Web), and the interface font is [Inter](https://fonts.google.com/specimen/Inter).
Interface icons are [from Google](https://fonts.google.com/icons).

On the default song display, the music icon is from [this Kenney pack](https://www.kenney.nl/assets/game-icons), and the right stick icon is based on one from [this pack](https://www.kenney.nl/assets/input-prompts).
