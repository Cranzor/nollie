extends Control
var delay1_lifted: bool = false
var delay2_lifted: bool = false
var delay1: float = 6.5 / 60.0
var delay2: float = 12.5 / 60.0
var timer1: float = 0
var timer2: float = 0
@onready var label = $Label

@onready var timer_node1 = $Timer
@onready var timer_node2 = $Timer2
@onready var audio_stream_player = $AudioStreamPlayer
var input_delay: int = 0

func _ready() -> void:
	$VBoxContainer/Continue.grab_focus()

func _physics_process(delta: float) -> void:
	var current_focus = get_viewport().gui_get_focus_owner()
	var next_focus = current_focus.find_next_valid_focus()
	
	if Input.is_action_just_pressed("menu_down"):
		input_delay = 3
		accept_event()
		next_focus.grab_focus()
		audio_stream_player.play()
		label.text = "Pressed"

	elif Input.is_action_pressed("menu_down"):
		input_delay = 3
		label.text = "Pressed"
		if timer_node2.is_stopped():
			timer_node2.start()

	elif Input.is_action_just_released("menu_down"):
		#timer_node1.one_shot = true
		label.text = "Not Pressed"
		#timer_node1.stop()
		#timer_node2.stop()
	
	else:
		if input_delay < 0:
			timer_node1.stop()
			timer_node2.stop()
	
	input_delay -= 1
	input_delay = clampi(input_delay, -1, 1)

#func _physics_process(delta: float) -> void:
	#var current_focus = get_viewport().gui_get_focus_owner()
	#var next_focus = current_focus.find_next_valid_focus()
	#
	#if Input.is_action_just_pressed("menu_down"):
		#accept_event()
		#next_focus.grab_focus()
	#elif Input.is_action_pressed("menu_down"):
		#timer2 += 1
		#if timer2 >= delay2:
			#timer1 += 1
			#if timer1 >= delay1:
				#accept_event()
				#next_focus.grab_focus()
				#timer1 = 0
	#else:
		#timer1 = 0
		#timer2 = 0
	
	
	#-----
	#if Input.is_action_pressed("menu_down", true):
		#accept_event()
		#next_focus.grab_focus()
	#elif Input.is_action_pressed("menu_up", true):
		#accept_event()
		#next_focus.grab_focus()


func _on_timer_timeout() -> void:
	var current_focus = get_viewport().gui_get_focus_owner()
	var next_focus = current_focus.find_next_valid_focus()
	accept_event()
	next_focus.grab_focus()
	audio_stream_player.play()
	#elif Input.is_action_just_released("menu_down"):
		#accept_event()
		#next_focus.grab_focus()
		#audio_stream_player.play()


func _on_timer_2_timeout() -> void:
	if timer_node1.is_stopped():
		timer_node1.one_shot = false
		timer_node1.start()
