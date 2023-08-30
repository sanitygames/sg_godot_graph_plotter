@tool
extends Panel
class_name SGGGraphPlotter

@export_range(-10000, 10000) var graph_scale: int = 0 : set = set_graph_scale
@export_range(1, 10000) var graph_resolution := 100: set = set_graph_resolution, get = get_graph_resolution
@export var CENTER_NORMAL = Vector2(0.5, 0.5): set = set_center_normal
@export_range(10, 100) var MINIMUM_GRID_SIZE := 20: set = set_minimum_pixel_grid_size
@export_range(2, 10, 1) var GRID_DIVISIONS := 5: set = set_grid_divisions
@export var VALUE_SCALE := Vector2(1.0, 1.0) : set = set_value_scale

var fn2draw = func(x): return cos(x)
var _graph_scale: float = 1.0



func _on_tree_entered():
	pass

func _on_item_rect_changed():
	if Engine.is_editor_hint():
		plot()

func set_graph_scale(value: int) -> void:
	graph_scale = value
	_graph_scale = pow(2.0, graph_scale / 1000.0)
	if Engine.is_editor_hint() && get_child_count() != 0:
		plot()

func set_graph_resolution(value: int) -> void:
	graph_resolution = value
	if Engine.is_editor_hint() && get_child_count() != 0:
		plot()

func get_graph_resolution() -> float:
	return graph_resolution

func set_center_normal(value: Vector2) -> void:
	CENTER_NORMAL = value
	if Engine.is_editor_hint() && get_child_count() != 0:
		plot()

func set_minimum_pixel_grid_size(value: int) -> void:
	MINIMUM_GRID_SIZE = value
	if Engine.is_editor_hint() && get_child_count() != 0:
		plot()

func set_grid_divisions(value: int) -> void:
	GRID_DIVISIONS = value
	if Engine.is_editor_hint() && get_child_count() != 0:
		plot()

func set_value_scale(value: Vector2) -> void:
	VALUE_SCALE = value
	if Engine.is_editor_hint() && get_child_count() != 0:
		plot()


func calc_grid_data() -> Dictionary:
	var p_origin_pos: Vector2 = size * CENTER_NORMAL
	var __magnitude: float = -floor(log(_graph_scale) / log(GRID_DIVISIONS))
	var p_grid_interval_length: float = MINIMUM_GRID_SIZE * _graph_scale * pow(GRID_DIVISIONS, __magnitude) + 0.00001
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
		flag_xs.push_back(n % GRID_DIVISIONS == 0)
		g_digits_xs.push_back(n / GRID_DIVISIONS)
		n += 1
		p_grid_pos_x += p_grid_interval_length
	
	var p_grid_pos_y = p_start_pos.y
	var pos_ys = []
	var flag_ys = []
	var g_digits_ys = []
	var m := int(-g_origin_pos.y + 1)
	while p_grid_pos_y >= 0 && p_grid_pos_y <= self.size.y:
		pos_ys.push_back(Vector2(p_origin_pos.x, p_grid_pos_y))
		flag_ys.push_back(m % GRID_DIVISIONS == 0)
		g_digits_ys.push_back(-m / GRID_DIVISIONS)
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

func plot_grid(data: Dictionary) -> void:
	$GridSpreader.draw(data, size)



func plot() -> void:
	if $GridSpreader.visible || $ScaleEmitter.visible:
		var data = calc_grid_data()
		if $GridSpreader.visible:
			$GridSpreader.draw(data, size)
		if $ScaleEmitter.visible:
			var magnitude = -floor(log(_graph_scale) / log(GRID_DIVISIONS))
			$ScaleEmitter.draw(data, VALUE_SCALE * pow(GRID_DIVISIONS, magnitude))


	if $GraphPlotter.visible:
		var n_origin := Vector2(CENTER_NORMAL.x , 1.0 - CENTER_NORMAL.y)
		var number_of_grid = self.size / MINIMUM_GRID_SIZE
		var __v_size: Vector2 = number_of_grid * (VALUE_SCALE/ GRID_DIVISIONS)
		var __v_position: Vector2 = -(__v_size) * n_origin
		var value_rect := Rect2(__v_position / _graph_scale * self.scale,  __v_size / _graph_scale * self.scale) 
		$GraphPlotter.draw(fn2draw, graph_resolution, self.get_rect(), value_rect)
		
