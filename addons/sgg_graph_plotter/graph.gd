@tool
extends Line2D


func plot(elements2plot, resolution, value_rect, pixel_rect):
	var _points = []
	if elements2plot is Callable:
		for i in resolution + 1:
			var normal_x = float(i) / resolution
			var value_x = value_rect.size.x * normal_x + value_rect.position.x
			var value_y = elements2plot.call(value_x)
			if value_y == null:
				points = []
				return
			var normal_y = inverse_lerp(value_rect.end.y, value_rect.position.y, value_y)
			var pixel_x = (pixel_rect.size.x * normal_x)
			var pixel_y = (pixel_rect.size.y * normal_y)
			_points.push_back(Vector2(pixel_x, pixel_y))

	elif elements2plot is Array:
		for p in elements2plot:
			if p is Vector2 || p is Vector2i:
				_points.push_back(p)

	else:
		return

	points = _points