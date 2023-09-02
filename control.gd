@tool
extends Control

var time = 0.0

# Called when the node enters the scene tree for the first time.
func _process(_delta):
	time += _delta
	$SGGGraphPlotter.callable_to_plot = func(x): return tan(x)
	$SGGGraphPlotter.array_to_plot = [Vector2(-0.5, 0.5) * sin(time), Vector2(1, 1)]
	$SGGGraphPlotter.plot()



