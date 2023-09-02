@tool
extends Line2D


func plot_callable(callable_to_plot: Callable, resolution: int, value_rect: Rect2, pixel_rect: Rect2) -> void:
	var _points = []
	if callable_to_plot.is_null():
		return
	else:
		for i in resolution + 1:
			var normal_x = float(i) / resolution
			var value_x = value_rect.size.x * normal_x + value_rect.position.x
			var value_y = callable_to_plot.call(value_x)
			var normal_y = inverse_lerp(value_rect.end.y, value_rect.position.y, value_y)
			var pixel_x = (pixel_rect.size.x * normal_x)
			var pixel_y = (pixel_rect.size.y * normal_y)
			_points.push_back(Vector2(pixel_x, pixel_y))

	points = _points

func plot_array(array_to_plot: PackedVector2Array, resolution: int, value_rect: Rect2, pixel_rect: Rect2) -> void:
	var _points = []
	for point in array_to_plot:
		var normal_x = inverse_lerp(value_rect.end.x, value_rect.position.x, point.x)
		var normal_y = inverse_lerp(value_rect.end.y, value_rect.position.y, point.y)
		var pixel_x = pixel_rect.size.x * normal_x
		var pixel_y = pixel_rect.size.y * normal_y
		_points.push_back(Vector2(pixel_x, pixel_y))
	points = _points