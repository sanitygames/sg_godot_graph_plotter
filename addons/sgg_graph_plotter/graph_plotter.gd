@tool
extends Line2D


func draw(data, resolution: int, p_rect: Rect2, v_rect: Rect2) -> void:

	var _points = []
	if data is Callable:
		for i in resolution + 1:
			var nx: float = float(i) / resolution 
			var vx: float = lerp(v_rect.position.x, v_rect.end.x, nx)
			var vy: float = data.call(vx)
			var ny: float = inverse_lerp(v_rect.position.y, v_rect.end.y, vy)
			var px: float = lerp(0.0, p_rect.size.x, nx)
			var py: float = lerp(p_rect.size.y, 0.0, ny)
			_points.push_back(Vector2(px, py))


		self.points = _points

	elif data is Array[Vector2]:
		var _data = PackedVector2Array(data)
		for p in _data:
			var nx: float = inverse_lerp(v_rect.position.x, v_rect.end.x, p.x)
			var ny: float = inverse_lerp(v_rect.position.y, v_rect.end.y, p.y)
			var px: float = lerp(0.0,  p_rect.size.x, nx)
			var py: float = lerp(p_rect.size.y, 0.0, ny)
			_points.push_back(Vector2(px, py))
		self.points = _points
	else:
		assert(false, "Invalid data")
