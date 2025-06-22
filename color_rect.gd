extends Node2D
@onready var polygon = $Area2D/CollisionPolygon2D

func _physics_process(_delta: float) -> void:
	_update_click_polygon()


### Updates the clickable area, preventing inputs from passing through the
### window outside of the defined region.
func _update_click_polygon() -> void:
	var click_polygon: PackedVector2Array = polygon.polygon
	for vec_i in range(click_polygon.size()):
		click_polygon[vec_i] = to_global(click_polygon[vec_i])
	get_window().mouse_passthrough_polygon = click_polygon
