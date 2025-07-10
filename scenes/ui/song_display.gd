extends Control

@export var song_display_theme: SongDisplayTheme
@onready var margin_container: MarginContainer = $MarginContainer
@onready var song_title: RichTextLabel = $MarginContainer/PanelContainer/HBoxContainer/SongTitle
@onready var song_title2: RichTextLabel = $MarginContainer/PanelContainer/HBoxContainer/ScrollContainer/MarginContainer/SongTitle2
@onready var scroll_container: ScrollContainer = $MarginContainer/PanelContainer/HBoxContainer/ScrollContainer
@onready var animation_timer: Timer = $AnimationTimer
@onready var scroll_start: Timer = $ScrollStart
var default_position: Vector2
var max_length: int = 750
var off_screen_pos: Vector2
var position_tween: Tween
var scroll_tween: Tween
var padding: Vector2 = Vector2(1, 0) # for 1 pixel gap on the right side of song display
var current_track_title: String = "The Kickflips - Nollie Onward"
var before_track_bb_code: String
var after_track_bb_code: String
var before_skip_bb_code: String
var after_skip_bb_code: String
var default_panel_style_box: StyleBoxFlat

var prev_position
func _ready() -> void:
	default_panel_style_box = panel_container.get_theme_stylebox("panel").duplicate()
	set_up_theme()
	default_position = position + padding
	off_screen_pos.y = default_position.y
	off_screen_pos.x = default_position.x + max_length
	position = off_screen_pos
	
	margin_container.resized.connect(_size_changed)
	animation_timer.timeout.connect(animation_disappear)
	scroll_start.timeout.connect(_scroll_start_timeout)
	
	GlobalSettings.song_display_offset_changed.connect(_adjust_song_display_offset)

func animation_appear(start_disappear_timer: bool) -> void:
	scroll_container.scroll_horizontal = 0
	if position.round() != default_position:
		if position_tween:
			position_tween.kill()
		position = off_screen_pos
		position_tween = create_tween()
		position_tween.set_trans(Tween.TRANS_CUBIC)
		position_tween.tween_property(self, "position", default_position, 0.8)
	
	if start_disappear_timer:
		animation_timer.wait_time = 3.0
		animation_timer.start()
		scroll_start.start()

func animation_disappear() -> void:
	position_tween = create_tween()
	position_tween.tween_property(self, "position", off_screen_pos, 0.3)

func update_song_title_labels(passed_title: String) -> void:
	scroll_container.hide()
	song_title.show()
	current_track_title = passed_title
	song_title.text = get_string_with_bb_code(before_track_bb_code, current_track_title, after_track_bb_code)
	song_title2.text = get_string_with_bb_code(before_track_bb_code, current_track_title, after_track_bb_code)

func update_skip_song_label() -> void:
	skip_text.text = get_string_with_bb_code(before_skip_bb_code, "Skip", after_skip_bb_code)

func get_string_with_bb_code(before_bb_code, passed_string, after_bb_code: String) -> String:
	var title_with_bb_code = before_bb_code + passed_string + after_bb_code
	return title_with_bb_code

func _size_changed() -> void:
	var size = margin_container.size
	var width = size.x
	
	if width >= max_length:
		song_title.hide()
		scroll_container.show()
	else:
		song_title.show()
		scroll_container.hide()

func _adjust_song_display_offset(new_pixel_offset: int) -> void:
	margin_container.add_theme_constant_override("margin_bottom", new_pixel_offset)

func _scroll_start_timeout() -> void:
	if scroll_container.visible:
		animation_timer.stop()
		var max_scroll = 10000
		scroll_container.scroll_horizontal = max_scroll
		var actual_max_scroll = scroll_container.scroll_horizontal
		scroll_container.scroll_horizontal = 0
		
		var scroll_tween = create_tween()
		scroll_tween.finished.connect(_on_scroll_tween_finished)
		scroll_tween.tween_property(scroll_container, "scroll_horizontal", actual_max_scroll, actual_max_scroll / 60.0)

func _on_scroll_tween_finished() -> void:
	animation_timer.wait_time = 1.0
	animation_timer.start()

@onready var music_icon = $MarginContainer/PanelContainer/HBoxContainer/MarginContainer3/MusicIcon
@onready var right_stick_icon = $MarginContainer/PanelContainer/HBoxContainer/MarginContainer2/RightStick
@onready var skip_text = $MarginContainer/PanelContainer/HBoxContainer/MarginContainer/Skip
@onready var panel_container = $MarginContainer/PanelContainer
func set_up_theme() -> void:
	theme = song_display_theme
	if song_display_theme.font:
		theme.default_font = song_display_theme.font
	
	song_title.add_theme_color_override("default_color", song_display_theme.track_text_font_color)
	song_title2.add_theme_color_override("default_color", song_display_theme.track_text_font_color)
	skip_text.add_theme_color_override("font_color", song_display_theme.skip_text_font_color)
	
	if song_display_theme.background_texture:
		var style_box_texture: StyleBoxTexture = StyleBoxTexture.new()
		style_box_texture.texture = song_display_theme.background_texture
		panel_container.add_theme_stylebox_override("panel", style_box_texture)
	else:
		var new_panel_container_style_box = default_panel_style_box.duplicate()
		new_panel_container_style_box.bg_color = song_display_theme.background_base_color
		panel_container.add_theme_stylebox_override("panel", new_panel_container_style_box)
	
	if song_display_theme.music_icon:
		music_icon.texture = song_display_theme.music_icon
	else:
		music_icon.texture = SongDisplayTheme.new().music_icon
	
	if song_display_theme.skip_song_icon:
		right_stick_icon.texture = song_display_theme.skip_song_icon
	else:
		right_stick_icon.texture = SongDisplayTheme.new().skip_song_icon
	
	#var new_panel_container_style_box = panel_container.get_theme_stylebox("panel").duplicate()
	#new_panel_container_style_box.bg_color = song_display_theme.background_base_color
	#panel_container.add_theme_stylebox_override("panel", new_panel_container_style_box)
	panel_container.self_modulate = song_display_theme.background_modulation
	music_icon.self_modulate = song_display_theme.music_icon_modulation
	right_stick_icon.self_modulate = song_display_theme.skip_song_icon_modulation
	
	music_icon.visible = song_display_theme.display_music_icon
	right_stick_icon.visible = song_display_theme.display_skip_song_icon
	skip_text.visible = song_display_theme.display_skip_song_text
	
	song_title.add_theme_color_override("font_shadow_color", song_display_theme.track_text_shadow_color)
	song_title2.add_theme_color_override("font_shadow_color", song_display_theme.track_text_shadow_color)
	song_title.add_theme_constant_override("shadow_outline_size", song_display_theme.track_text_shadow_size)
	song_title2.add_theme_constant_override("shadow_outline_size", song_display_theme.track_text_shadow_size)
	skip_text.add_theme_color_override("font_shadow_color", song_display_theme.skip_text_shadow_color)
	skip_text.add_theme_constant_override("shadow_outline_size", song_display_theme.skip_text_shadow_size)
	
	#var song_name = song_title.text
	#var song_name2 = song_title2.text
	#song_title.text = song_display_theme.before_track_text_bbcode + song_name + song_display_theme.after_track_text_bbcode
	#song_title2.text = song_display_theme.before_track_text_bbcode + song_name2 + song_display_theme.after_track_text_bbcode
	before_track_bb_code = song_display_theme.before_track_text_bbcode
	after_track_bb_code = song_display_theme.after_track_text_bbcode
	before_skip_bb_code = song_display_theme.before_skip_text_bbcode
	after_skip_bb_code = song_display_theme.after_skip_text_bbcode
	update_song_title_labels(current_track_title)
	update_skip_song_label()

#TODO: display song when pausing
