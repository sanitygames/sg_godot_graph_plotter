@tool
extends SGGGraphPlotter

var time = 0.0

func _process(delta):
	time += delta * 10.0
	callable_to_plot = func(x): return cos(x + time) * 10.0
	plot()
