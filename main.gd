extends Node2D

@onready var gopotify: GopotifyClient = $Gopotify
var paused: bool = false
@onready var window: Window = $Window
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var label = $Window/Control/ColorRect/ScrollContainer/Label
@onready var scroll_container = $Window/Control/ColorRect/ScrollContainer
var animation_started: bool = false

func _ready() -> void:
	window.size = DisplayServer.screen_get_size()
	window.size.y += 40
	label.text = await gopotify.get_current_track()
	gopotify.play()

var last_pos: int
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("next_song"):
		gopotify.next()
		$Timer.start()
	
	if Input.is_action_just_pressed("previous_song"):
		gopotify.previous()
		$Timer.start()
	
	if Input.is_action_just_pressed("pause"):
		paused = !paused
		if paused:
			gopotify.set_volume(60)
		else:
			gopotify.set_volume(80)

	last_pos = scroll_container.scroll_horizontal
	if animation_started:
		scroll_container.scroll_horizontal += 1
		if last_pos == scroll_container.scroll_horizontal:
			animation_started = false
			animation_player.stop()
			animation_player.play("fade")


func _on_window_close_requested() -> void:
	window.hide()


func _on_timer_timeout() -> void:
	animation_started = false
	scroll_container.scroll_horizontal = 0
	label.text = await gopotify.get_current_track()
	$Timer2.start()


func _on_timer_2_timeout() -> void:
	$Window/Control/ColorRect.modulate = Color(1, 1, 1, 1)
	scroll_container.scroll_horizontal = 0
	animation_started = true
