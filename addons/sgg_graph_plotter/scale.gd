@tool
extends Node2D

@export var font: Font: set = set_font
@export var font_size: int = 12: set = set_font_size
@export var font_color := Color.WHITE: set = set_font_color
@export var outline_size: int = 1: set = set_outline_size
@export var outline_color := Color.BLACK: set = set_outline_color

var labels = []

func plot(pixel_origin, grid_divisions, subgrid_start_count, subgrid_start_position, subgrid_count, subgrid_size, value_par_rect, scale):
	var __ = labels.map(func(l): l.queue_free())
	labels.clear()

	for nx in subgrid_count.x:
		if int(subgrid_start_count.x + nx) % int(grid_divisions) == 0:
			var _label: Label = Label.new()
			add_child(_label)
			_label.text = "%.2f" % ((subgrid_start_count.x + nx) * float(value_par_rect.x / grid_divisions / scale))
			if font != null:
				_label.add_theme_font_override("font", font)
			_label.add_theme_font_size_override("font_size", font_size)
			_label.add_theme_color_override("font_color", font_color)
			_label.add_theme_color_override("font_outline_color", outline_color)
			_label.add_theme_constant_override("outline_size", outline_size)
			_label.position.x = subgrid_start_position.x + subgrid_size * nx
			_label.position.y = pixel_origin.y
			labels.push_back(_label)

	for ny in subgrid_count.y:
		if subgrid_start_count.y + ny == 0:
			continue
		elif int(subgrid_start_count.y + ny) % int(grid_divisions) == 0:
			var _label = Label.new()
			add_child(_label)
			_label.text = "%.2f" % ((subgrid_start_count.y + ny) * float(value_par_rect.y / grid_divisions / scale))
			if font != null:
				_label.add_theme_font_override("font", font)
			_label.add_theme_font_size_override("font_size", font_size)
			_label.add_theme_color_override("font_color", font_color)
			_label.add_theme_color_override("font_outline_color", outline_color)
			_label.add_theme_constant_override("outline_size", outline_size)
			_label.position.x = pixel_origin.x
			_label.position.y = subgrid_start_position.y + subgrid_size * ny
			labels.push_back(_label)

func set_font(value: Font) -> void:
	font = value
	if get_parent() != null && Engine.is_editor_hint():
		get_parent().plot()
	
func set_font_size(value: int) -> void:
	font_size = max(1, value)
	if get_parent() != null && Engine.is_editor_hint():
		get_parent().plot()

func set_font_color(value: Color) -> void:
	font_color = value
	if get_parent() != null && Engine.is_editor_hint():
		get_parent().plot()

func set_outline_size(value: int) -> void:
	outline_size = max(0, value)
	if get_parent() != null && Engine.is_editor_hint():
		get_parent().plot()

func set_outline_color(value: Color) -> void:
	outline_color = value
	if get_parent() != null && Engine.is_editor_hint():
		get_parent().plot()
