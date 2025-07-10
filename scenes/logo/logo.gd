extends Node2D

func _ready() -> void:
	DisplayServer.window_set_size(Vector2i(256, 256))
	var viewport: Viewport = get_viewport()
	var texture = viewport.get_texture()
	await RenderingServer.frame_post_draw
	var err = viewport.get_texture().get_image().save_png("res://icons/logo.png")
