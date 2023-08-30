extends SGGGraphPlotter


var time = 0.0
func _ready():
	plot()
	self.data = func(x): return round(sin(x + time * 0.2)) * randf()


func _process(delta):
	plot()
