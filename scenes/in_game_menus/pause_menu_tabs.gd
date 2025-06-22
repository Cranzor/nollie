extends Control
#@onready var pause = $HBoxContainer/Pause
#@onready var profile = $HBoxContainer/Profile

func _ready() -> void:
	$HBoxContainer/Pause.grab_focus()

#func _physics_process(delta: float) -> void:
	#var current_focus = get_viewport().gui_get_focus_owner()
	#
	#if Input.is_action_just_pressed("menu_tab_right"):
		#var next_focus = current_focus.find_next_valid_focus()
		#if next_focus != pause:
			#accept_event()
			#next_focus.grab_focus()
	#elif Input.is_action_just_pressed("menu_tab_left"):
		#var prev_focus = current_focus.find_prev_valid_focus()
		#if prev_focus != profile:
			#accept_event()
			#prev_focus.grab_focus()
