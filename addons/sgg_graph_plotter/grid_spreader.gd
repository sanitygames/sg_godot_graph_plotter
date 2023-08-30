@tool
extends Control

var _data := {}
var _size := Vector2.ZERO

var _width: float = 10.0
var _color := Color.GRAY 
var _c0 = 0.6
var _c1 = 0.3
var _c2 = 1.0

func draw(data: Dictionary, rect_size: Vector2) -> void:
	_data = data
	_size = rect_size
	_color = Color.GRAY
	_width = 1.0
	_c0 = 0.6
	_c1 = 0.3
	_c2 = 1.0
	queue_redraw()

func _draw():
	if _data.is_empty():
		return


	var pos_xs = _data.x.positions.map(func(v): return [Vector2(v.x, 0), Vector2(v.x, _size.y)])
	var pos_ys = _data.y.positions.map(func(v): return [Vector2(0, v.y), Vector2(_size.x, v.y)])

	_draw_line_helper(pos_xs, _data.x.flags, _data.x.g_digits)
	_draw_line_helper(pos_ys, _data.y.flags, _data.y.g_digits)

func _draw_line_helper(positions: Array, flags: Array, digits: Array) -> void:
	for i in positions.size():
		var c: float = _c0 if flags[i] else _c1
		c = _c2 if flags[i] && digits[i] == 0 else c
		draw_line(positions[i][0], positions[i][1], _color * c, _width ,true)