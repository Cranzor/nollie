extends Node2D


## A Godot object that moves randomly around the screen.


@onready var _ClickPolygon: CollisionPolygon2D = $CollisionPolygon2D

	
func _physics_process(_delta: float) -> void:
	var song_display_size = get_parent().margin_container.size
	var size_to_polygon: PackedVector2Array = [Vector2(-song_display_size.x, -song_display_size.y), Vector2(0, -song_display_size.y), Vector2(0, 0), Vector2(-song_display_size.x, 0)]
	_ClickPolygon.polygon = size_to_polygon
	_update_click_polygon()


## Updates the clickable area, preventing inputs from passing through the
## window outside of the defined region.
func _update_click_polygon() -> void:
	var click_polygon: PackedVector2Array = _ClickPolygon.polygon
	for vec_i in range(click_polygon.size()):
		click_polygon[vec_i] = to_global(click_polygon[vec_i])
	get_window().mouse_passthrough_polygon = click_polygon


### A simple function that changes the position of the Godot icon randomly.
#func _on_click_area_input_event(_viewport: Node, event: InputEvent,
		#_shape_idx: int) -> void:
	#if event is InputEventMouseButton and event.is_pressed():
		#var window_size: Vector2i = get_window().size
		#global_position = Vector2(randf_range(0, window_size.x),
				#randf_range(0, window_size.y))
