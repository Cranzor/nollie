extends Control

@onready var margin_container: MarginContainer = $MarginContainer
@onready var song_title: Label = $MarginContainer/PanelContainer/HBoxContainer/SongTitle
@onready var song_title2: Label = $MarginContainer/PanelContainer/HBoxContainer/ScrollContainer/SongTitle2
@onready var scroll_container: ScrollContainer = $MarginContainer/PanelContainer/HBoxContainer/ScrollContainer
@onready var animation_timer: Timer = $AnimationTimer
var default_position: Vector2
var max_length: int = 745
var off_screen_pos: Vector2
var position_tween: Tween

var prev_position
func _ready() -> void:
	default_position = position
	off_screen_pos.y = default_position.y
	off_screen_pos.x = default_position.x + max_length
	position = off_screen_pos
	
	margin_container.resized.connect(_size_changed)
	animation_timer.timeout.connect(animation_disappear)

func animation_appear() -> void:
	if position.round() != default_position:
		if position_tween:
			position_tween.kill()
		position = off_screen_pos
		position_tween = create_tween()
		position_tween.set_trans(Tween.TRANS_CUBIC)
		position_tween.tween_property(self, "position", default_position, 0.8)
	animation_timer.start()

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

#TODO: display song when pausing
