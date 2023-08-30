@tool
extends Node2D

var _labels = []

func draw(data: Dictionary, grid_scale: Vector2) -> void:
	for l in _labels:
		l.queue_free()
	_labels.clear()
	_draw_scale_helper(data.x, grid_scale.x)
	_draw_scale_helper(data.y, grid_scale.y)

func _draw_scale_helper(d: Dictionary, grid_scale: float) -> void:
	for i in d.positions.size():
		if d.flags[i]:
			var _l = Label.new()
			_l.text = "%.2f" % (d.g_digits[i] * grid_scale)
			_l.position = d.positions[i]
			_labels.push_back(_l)
			add_child(_l)
