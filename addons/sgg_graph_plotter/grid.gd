@tool
extends Node2D

@export var grid_width: float = 1.0:
	set = set_grid_width,
	get = get_grid_width
@export var grid_color: Color = Color.GRAY:
	set = set_grid_color,
	get = get_grid_color
@export var subgrid_width: float = 1.0:
	set = set_subgrid_width,
	get = get_subgrid_width
@export var subgrid_color: Color = Color.GRAY * 0.5:
	set = set_subgrid_color,
	get = get_subgrid_color
@export var axis_width: float = 1.0:
	set = set_axis_width,
	get = get_axis_width
@export var axis_x_color: Color = Color.GRAY:
	set = set_axis_x_color,
	get = get_axis_x_color
@export var axis_y_color: Color = Color.GRAY:
	set = set_axis_y_color,
	get = get_axis_y_color



var _grid_start_position
var _grid_start_count 
var _subgrid_count
var _subgrid_size
var _grid_divisions
var _pixel_rect

func plot(pixel_rect, grid_start_position, grid_start_count, subgrid_count, subgrid_size, grid_divisions):
	_pixel_rect = pixel_rect
	_grid_start_position = grid_start_position
	_grid_start_count = grid_start_count
	_subgrid_count = subgrid_count
	_subgrid_size = subgrid_size
	_grid_divisions = grid_divisions

	queue_redraw()

func _draw():
	# Draw vartical lines
	for nx in _subgrid_count.x:
		var c = subgrid_color
		var w = subgrid_width
		if _grid_start_count.x + nx == 0:
			c = axis_y_color
			w = axis_width
		elif int(_grid_start_count.x + nx) % int(_grid_divisions) == 0:
			c = grid_color
			w = grid_width
		var s = Vector2(_grid_start_position.x + _subgrid_size * nx, 0)
		var e = Vector2(_grid_start_position.x + _subgrid_size * nx, _pixel_rect.size.y)
		draw_line(s, e, c, w)

	# Draw horizontal lines
	for ny in _subgrid_count.y:
		var c = subgrid_color
		var w = subgrid_width
		if _grid_start_count.y + ny == 0:
			c = axis_x_color
			w = axis_width
		elif int(_grid_start_count.y + ny) % int(_grid_divisions) == 0:
			c = grid_color
			w = grid_width
		var s = Vector2(0, _grid_start_position.y + _subgrid_size * ny)
		var e = Vector2(_pixel_rect.size.x, _grid_start_position.y + _subgrid_size * ny)
		draw_line(s, e, c, w)



func set_grid_width(value: float) -> void:
	grid_width = value
	if Engine.is_editor_hint():
		queue_redraw()

func get_grid_width() -> float:
	return grid_width

func set_grid_color(value: Color) -> void:
	grid_color = value
	if Engine.is_editor_hint():
		queue_redraw()

func get_grid_color() -> Color:
	return grid_color

func set_subgrid_width(value: float) -> void:
	subgrid_width = value
	if Engine.is_editor_hint():
		queue_redraw()

func get_subgrid_width() -> float:
	return subgrid_width

func set_subgrid_color(value: Color) -> void:
	subgrid_color = value
	if Engine.is_editor_hint():
		queue_redraw()

func get_subgrid_color() -> Color:
	return subgrid_color

func set_axis_width(value: float) -> void:
	axis_width = value
	if Engine.is_editor_hint():
		queue_redraw()

func get_axis_width() -> float:
	return axis_width

func set_axis_x_color(value: Color) -> void:
	axis_x_color = value
	if Engine.is_editor_hint():
		queue_redraw()

func get_axis_x_color() -> Color:
	return axis_x_color

func set_axis_y_color(value: Color) -> void:
	axis_y_color = value
	if Engine.is_editor_hint():
		queue_redraw()

func get_axis_y_color() -> Color:
	return axis_y_color