extends SGGGraphPlotter


@onready var spectrum = AudioServer.get_bus_effect_instance(0, 0)

func _ready():
	self.fn2draw = func(x): 
		var range = 11050.0 / self.get_graph_resolution()
		var m = spectrum.get_magnitude_for_frequency_range(x*range, x*range + range).length()
		return  linear_to_db(m)


func _process(delta):
	plot()
