@tool
extends Panel
class_name SGGGraphPlotter

@export_range(-10000, 10000) var graph_scale: int = 0 : set = set_graph_scale, get = get_graph_scale
@export_range(1, 1000) var line_resolution := 100: set = set_graph_resolution, get = get_graph_resolution
@export var center_normal = Vector2(0.5, 0.5): set = set_center_normal, get = get_center_normal
@export var value_par_grid := Vector2(1.0, 1.0) : set = set_value_par_grid, get = get_value_par_grid
@export_range(10, 100) var minimum_grid_size := 20: set = set_minimum_pixel_grid_size
@export_range(2, 10, 1) var grid_divisions := 5: set = set_grid_divisions
@export var graph_visible := true
@export var grid_visible := true
@export var scale_visible := true

var func2plot = func(x): return cos(x) : set = set_func2plot, get = get_func2plot
var points2plot = [] : set = set_points2plot, get = get_points2plot
var _graph_scale: float = 1.0

var _grid_data

#  [~~~~~~~~~~~~~~~~\
#  |  Actions		|
#  |___  ___________|
#      V

func _enter_tree():
	print("enter tree")
	item_rect_changed.connect(_on_item_rect_changed)
	self.clip_contents = true
	var dict = {
		"GridSpreader": [
			"res://addons/sgg_graph_plotter/grid_spreader.gd", 
			func(): return Node2D.new()],
		"GraphPlotter": [
			"res://addons/sgg_graph_plotter/graph_plotter.gd", 
			func(): return Line2D.new()],
		"ScaleEmitter": [
			"res://addons/sgg_graph_plotter/scale_emitter.gd",
			func(): return Node2D.new()],
	}

	for key in dict:
		if !has_node(key):
			var __n = dict[key][1].call()
			__n.name = key
			__n.position = Vector2.ZERO
			__n.set_script(load(dict[key][0]))
			add_child(__n)

	plot()


func _exit_tree():
	pass

func _on_item_rect_changed():
	print("on_item_rect_changed")
	if Engine.is_editor_hint():
			plot()

#  [~~~~~~~~~~~~~~~~\
#  |  Methods		|
#  |___  ___________|
#      V

func plot() -> void:
	print("plot")
	if grid_visible || scale_visible:
		_grid_data = _calc_grid_data()
	
	if grid_visible:
		$GridSpreader.draw(_grid_data, self.size)
	
	if graph_visible:
		var n_origin := Vector2(center_normal.x , 1.0 - center_normal.y)
		var number_of_grid = self.size / minimum_grid_size
		var __v_size: Vector2 = number_of_grid * (value_par_grid/ grid_divisions)
		var __v_position: Vector2 = -(__v_size) * n_origin
		var value_rect := Rect2(__v_position / _graph_scale * self.scale,  __v_size / _graph_scale * self.scale) 
		$GraphPlotter.draw(func2plot, line_resolution, self.get_rect(), value_rect)

	if scale_visible:
		$ScaleEmitter.draw(_grid_data, self.size)


#  [~~~~~~~~~~~~~~\
#  |  private     |
#  |___  _________|
#      V

func _calc_grid_data() -> Dictionary:
	var p_origin_pos: Vector2 = size * center_normal
	var __magnitude: float = -floor(log(_graph_scale) / log(grid_divisions))
	var p_grid_interval_length: float = minimum_grid_size * _graph_scale * pow(grid_divisions, __magnitude) + 0.00001
	var p_start_pos: Vector2 = p_origin_pos.posmod(p_grid_interval_length)
	var g_origin_pos: Vector2 = ceil(p_origin_pos /p_grid_interval_length)
	var __check_rect := Rect2(Vector2.ZERO, self.size)

	var p_grid_pos_x = p_start_pos.x
	var pos_xs = []
	var flag_xs = []
	var g_digits_xs = [] 
	var n := int(-g_origin_pos.x + 1) 
	while p_grid_pos_x >= 0 && p_grid_pos_x <= self.size.x:
		pos_xs.push_back(Vector2(p_grid_pos_x, p_origin_pos.y))
		flag_xs.push_back(n % grid_divisions == 0)
		g_digits_xs.push_back(n / grid_divisions)
		n += 1
		p_grid_pos_x += p_grid_interval_length
	
	var p_grid_pos_y = p_start_pos.y
	var pos_ys = []
	var flag_ys = []
	var g_digits_ys = []
	var m := int(-g_origin_pos.y + 1)
	while p_grid_pos_y >= 0 && p_grid_pos_y <= self.size.y:
		pos_ys.push_back(Vector2(p_origin_pos.x, p_grid_pos_y))
		flag_ys.push_back(m % grid_divisions == 0)
		g_digits_ys.push_back(-m / grid_divisions)
		m += 1
		p_grid_pos_y += p_grid_interval_length

	return {
		"x":
			{
				"positions": pos_xs,
				"flags": flag_xs,
				"g_digits": g_digits_xs,
			},
		"y":
			{
				"positions": pos_ys,
				"flags": flag_ys,
				"g_digits": g_digits_ys,
			},
	}

#  [~~~~~~~~~~~~~~~~~~~\
#  |  Setter & Getter  |
#  |___  ______________|
#      V

func set_graph_scale(value: int) -> void:
	graph_scale = value
	_graph_scale = pow(2.0, graph_scale / 1000.0)
	if Engine.is_editor_hint() && get_child_count() != 0:
		plot()
	
func get_graph_scale() -> int:
	return graph_scale

func set_graph_resolution(value: int) -> void:
	line_resolution = clamp(value, 1, 1000)
	if Engine.is_editor_hint() && get_child_count() != 0:
		plot()

func get_graph_resolution() -> float:
	return line_resolution

func set_center_normal(value: Vector2) -> void:
	center_normal = value
	if Engine.is_editor_hint() && get_child_count() != 0:
		plot()

func get_center_normal() -> Vector2:
	return center_normal

func set_value_par_grid(value: Vector2) -> void:
	value_par_grid = value
	if Engine.is_editor_hint() && get_child_count() != 0:
		plot()

func get_value_par_grid() -> Vector2:
	return value_par_grid

func set_minimum_pixel_grid_size(value: int) -> void:
	minimum_grid_size = value
	if Engine.is_editor_hint() && get_child_count() != 0:
		plot()

func set_grid_divisions(value: int) -> void:
	grid_divisions = value
	if Engine.is_editor_hint() && get_child_count() != 0:
		plot()

func set_func2plot(value: Callable) -> void:
	func2plot = value

func get_func2plot() -> Callable:
	return func2plot

func set_points2plot(value: Array[Vector2]) -> void:
	points2plot = value

func get_points2plot() -> Array[Vector2]:
	return points2plot