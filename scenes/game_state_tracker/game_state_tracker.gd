extends Node
var paused: bool = false:
	set(value):
		if value != paused:
			emit_signal("pause_status_changed", !paused)
			print(!paused)
			GlobalSettings.paused = !paused
		paused = value
		
signal pause_status_changed(paused_status)

@onready var a_button_timer = $AButtonTimer
@onready var left_right_timer = $LeftRightTimer

var quit_button_combo: Array[String] = ["menu_accept", "menu_left", "menu_accept"]
var last_three_inputs: Array[String] = ["", "", ""]

#var reverb_enabled: bool = false

func _physics_process(delta: float) -> void:
	check_input_held("gain_speed", a_button_timer)
	check_input_held("move_horizontal", left_right_timer)
	check_paused()
	if paused:
		check_quit_button_combo()
	
	#if reverb_enabled:
		#AudioServer.set_bus_effect_enabled(0, 0, true)
	#else:
		#AudioServer.set_bus_effect_enabled(0, 0, false)


func _on_a_button_timer_timeout() -> void:
	paused = false

func check_input_held(input_name, timer):
	if Input.is_action_pressed(input_name):
		if timer.is_stopped():
			timer.start()
	else:
		timer.stop()


func _on_left_right_timer_timeout() -> void:
	paused = false

func check_paused():
	if Input.is_action_just_released("pause"):
		paused = !paused

func check_quit_button_combo():
	if Input.is_action_just_pressed("menu_accept"):
		last_three_inputs.append("menu_accept")
		last_three_inputs.pop_front()
	elif Input.is_action_just_pressed("menu_left"):
		last_three_inputs.append("menu_left")
		last_three_inputs.pop_front()
	
	if last_three_inputs == quit_button_combo:
		paused = false
		last_three_inputs = ["", "", ""]
