extends TextureButton

func _ready() -> void:
	if disabled:
		darken_button_color()
	
	self.connect("mouse_entered", _self_mouse_entered)
	self.connect("mouse_exited", _self_mouse_exited)
	self.connect("pressed", _test)

func _self_mouse_entered() -> void:
	darken_button_color()

func _self_mouse_exited() -> void:
	if not disabled:
		reset_button_color()

func darken_button_color() -> void:
	self_modulate = Color(0.805, 0.805, 0.805)

func reset_button_color() -> void:
	self_modulate = Color(1.0, 1.0, 1.0)

func _test() -> void:
	print("clicked")
