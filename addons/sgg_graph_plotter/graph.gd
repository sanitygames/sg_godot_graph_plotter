@tool
extends Line2D

func test_plot(to_plot, resolution, value_rect, pixel_rect):
	var _points = []
	width = 1.0
	if to_plot is Callable:
		for i in resolution + 1:
			var normal_x = float(i) / resolution
			var value_x = value_rect.size.x * normal_x + value_rect.position.x
			var value_y = to_plot.call(value_x)
			var normal_y = inverse_lerp(value_rect.end.y, value_rect.position.y, value_y)
			var pixel_x = pixel_rect.size.x * normal_x + pixel_rect.position.x
			var pixel_y = pixel_rect.size.y * normal_y + pixel_rect.position.y
			_points.push_back(Vector2(pixel_x, pixel_y))

	points = _points
