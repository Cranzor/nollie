extends Theme
class_name SongDisplayTheme

@export_category("Font")
@export var font: FontFile

@export_category("Font Colors")
@export var track_text_font_color: Color = Color(1.0, 1.0, 1.0)
@export var skip_text_font_color: Color = Color(0.671, 0.694, 0.714)

@export_category("Font Shadows")
@export var track_text_shadow_color: Color
@export var skip_text_shadow_color: Color
@export var track_text_shadow_size: int = 1
@export var skip_text_shadow_size: int = 1

@export_category("Textures")
@export var background_texture: Texture
@export var music_icon: Texture = preload("res://icons/musicOn.png")
@export var skip_song_icon: Texture = preload("res://icons/xbox_rs_outline_orange_gray.png")

@export_category("Color Modulation")
@export var background_base_color: Color = Color(0.059, 0.059, 0.059, 0.784)
@export var background_modulation: Color = Color(1, 1, 1, 0.78)
@export var music_icon_modulation: Color = Color.WHITE
@export var skip_song_icon_modulation: Color = Color.WHITE

@export_category("Hide Sections")
@export var display_music_icon: bool = true
@export var display_skip_song_icon: bool = true
@export var display_skip_song_text: bool = true

@export_category("BBCode")
@export var before_track_text_bbcode: String
@export var after_track_text_bbcode: String
@export var before_skip_text_bbcode: String
@export var after_skip_text_bbcode: String
