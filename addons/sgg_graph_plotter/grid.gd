@tool
extends Node2D

var _pos
var _count 
var _size

func test_plot(pos, count, size):
	_pos = pos
	_count = count
	_size = size

	queue_redraw()

func _draw():
	var _p = _pos
	for x in _count.x:
		draw_line(
			Vector2(_p.x + x * _size, 0),
			Vector2(_p.x + x * _size, 1000),
			Color.WHITE,
			1.0,
			true
		)

