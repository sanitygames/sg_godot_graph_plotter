@tool
extends Node2D

var _grid_start_position
var _grid_start_count 
var _subgrid_count
var _subgrid_size
var _grid_divisions

func test_plot(grid_start_position, grid_start_count, subgrid_count, subgrid_size, grid_divisions):
	_grid_start_position = grid_start_position
	_grid_start_count = grid_start_count
	_subgrid_count = subgrid_count
	_subgrid_size = subgrid_size
	_grid_divisions = grid_divisions

	queue_redraw()

func _draw():
	if _grid_start_position == null:
		return
	for i in _subgrid_count.x:
		var c = Color.GRAY
		if int(_grid_start_count.x + i) % int(_grid_divisions) == 0:
			c = Color.RED
		var s = Vector2(_grid_start_position.x + _subgrid_size * i, 0)
		var e = Vector2(_grid_start_position.x + _subgrid_size * i, 1000)
		draw_line(s, e, c, 1.0)

