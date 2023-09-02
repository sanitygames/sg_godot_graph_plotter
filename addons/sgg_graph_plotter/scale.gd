@tool
extends Node2D

var labels = []

func test_plot(pixel_origin, grid_divisions, subgrid_start_count, subgrid_start_position, subgrid_count, subgrid_size, value_par_rect, scale):
	for l in labels:
		l.queue_free()
	labels.clear()

	for i in subgrid_count.x:
		if int(subgrid_start_count.x + i) % int(grid_divisions) == 0:
			var _label = Label.new()
			add_child(_label)
			_label.text = "%.2f" % ((subgrid_start_count.x + i) * float(value_par_rect.x / grid_divisions / scale))
			_label.position.x = subgrid_start_position.x + subgrid_size * i
			labels.push_back(_label)
