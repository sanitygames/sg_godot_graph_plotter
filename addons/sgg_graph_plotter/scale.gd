@tool
extends Node2D

var labels = []

func plot(pixel_origin, grid_divisions, subgrid_start_count, subgrid_start_position, subgrid_count, subgrid_size, value_par_rect, scale):
	var __ = labels.map(func(l): l.queue_free())
	labels.clear()

	for nx in subgrid_count.x:
		if int(subgrid_start_count.x + nx) % int(grid_divisions) == 0:
			var _label = Label.new()
			add_child(_label)
			_label.text = "%.2f" % ((subgrid_start_count.x + nx) * float(value_par_rect.x / grid_divisions / scale))
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
			_label.position.x = pixel_origin.x
			_label.position.y = subgrid_start_position.y + subgrid_size * ny
			labels.push_back(_label)

	
