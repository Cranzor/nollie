extends Control

@onready var margin_container: MarginContainer = $MarginContainer
@onready var song_title: Label = $MarginContainer/PanelContainer/HBoxContainer/SongTitle
@onready var song_title2: Label = $MarginContainer/PanelContainer/HBoxContainer/ScrollContainer/MarginContainer/SongTitle2
@onready var scroll_container: ScrollContainer = $MarginContainer/PanelContainer/HBoxContainer/ScrollContainer
@onready var animation_timer: Timer = $AnimationTimer
@onready var scroll_start: Timer = $ScrollStart
var default_position: Vector2
var max_length: int = 750
var off_screen_pos: Vector2
var position_tween: Tween
var scroll_tween: Tween
var padding: Vector2 = Vector2(1, 0) # for 1 pixel gap on the right side of song display

var prev_position
func _ready() -> void:
	default_position = position + padding
	off_screen_pos.y = default_position.y
	off_screen_pos.x = default_position.x + max_length
	position = off_screen_pos
	
	margin_container.resized.connect(_size_changed)
	animation_timer.timeout.connect(animation_disappear)
	scroll_start.timeout.connect(_scroll_start_timeout)
	
	GlobalSettings.song_display_offset_changed.connect(_adjust_song_display_offset)

func animation_appear() -> void:
	scroll_container.scroll_horizontal = 0
	if position.round() != default_position:
		if position_tween:
			position_tween.kill()
		position = off_screen_pos
		position_tween = create_tween()
		position_tween.set_trans(Tween.TRANS_CUBIC)
		position_tween.tween_property(self, "position", default_position, 0.8)
	
	animation_timer.wait_time = 3.0
	animation_timer.start()
	scroll_start.start()

func animation_disappear() -> void:
	position_tween = create_tween()
	position_tween.tween_property(self, "position", off_screen_pos, 0.3)

func update_song_title_labels(passed_title: String) -> void:
	scroll_container.hide()
	song_title.show()
	song_title.text = passed_title
	song_title2.text = passed_title

func _size_changed() -> void:
	var size = margin_container.size
	var width = size.x
	
	if width >= max_length:
		song_title.hide()
		scroll_container.show()
		#TODO: animation_timer.stop() and then set it once scrolling finishes
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

#TODO: display song when pausing
