extends Button

func _gui_input(event: InputEvent) -> void:
	if has_focus():
		if event.is_action_pressed("ui_text_completion_replace", true):
			accept_event() # prevent the normal focus-stuff from happening
			find_next_valid_focus().grab_focus()
