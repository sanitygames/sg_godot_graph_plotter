@tool
extends Panel
class_name SGGGraphPlotter


# ==============================================================================
# ┌────────┬───────┬───────┬───────┬────────┐ Sanity
# │ ┌──────┤ ┌─────┤ ┌─────┤ ┌─────┤ ┌────┐ │ Games
# │ │ ─────┤ │ ┌─┬─┤ │ ┌─┬─┤ │ ┌─┬─┤ │ ┌─ │ │ Godot
# │ └────┐ │ │ │ │ │ │ │ │ │ │ │ │ │ │ ├──┘ │ Graph
# ├───── │ │ │ │ │ │ │ │ │ │ │ │ │ │ │ ├────┘ Plotter
# ├──────┘ │ └───┘ │ └───┘ │ └───┘ │ │ │      ----------------------------------
# └────────┴───────┴───────┴───────┴─┴─┘	  Ver.0.2.0
# ==============================================================================


@export_group("Coordinate")
@export_range(0.0001, 1000000) var zoom :float = 1.0: 
	set = set_zoom, 
	get = get_zoom
@export var normalized_origin := Vector2(0.5, 0.5): 
	set = set_normalized_origin, 
	get = get_normalized_origin
@export var value_par_grid := Vector2.ONE: 
	set = set_value_par_grid, 
	get = get_value_par_grid
@export_subgroup("AdvancedSettings")
@export_range(1, 1000) var graph_resolution: int = 100: 
	set = set_graph_resolution, 
	get = get_graph_resolution
@export var minimum_subgrid_size: float = 10.0:
	set = set_minimum_subgrid_size,
	get = get_minimum_subgrid_size
@export var grid_divisions: int = 5:
	set = set_grid_divisions,
	get = get_grid_divisions

var callable_to_plot: Callable: 
	set = set_function_to_plot,
	get = get_function_to_plot
var array_to_plot := PackedVector2Array():
	set = set_array_to_plot,
	get = get_array_to_plot

var is_callable := true
var zoom_pow = 1.0



# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Actions
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
func _enter_tree():
	if !item_rect_changed.is_connected(_on_item_rect_changed):
		item_rect_changed.connect(_on_item_rect_changed)
	self.clip_contents = true

	var dict = {
		"Grid": {
			fn = func(): return Node2D.new(),
			path = "res://addons/sgg_graph_plotter/grid.gd",
		},
		"Graph": {
			fn = func(): return Line2D.new(),
			path = "res://addons/sgg_graph_plotter/graph.gd",
		},
		"Scale": {
			fn = func(): return Node2D.new(),
			path = "res://addons/sgg_graph_plotter/scale.gd",
		},
	}

	for key in dict:
		if !has_node(key):
			var _node = dict[key].fn.call()
			add_child(_node)
			_node.name = key
			_node.position = Vector2.ZERO
			_node.set_script(load(dict[key].path))
			_node.set_owner(get_tree().edited_scene_root)

	# element2plot = func(x): return sin(x)
	plot()

func _on_item_rect_changed():
	if Engine.is_editor_hint() && _is_child_node_ready():
		plot()



# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Methods
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
func set_something_to_plot(value) -> void:
	is_callable = value is Callable
	if is_callable:
		callable_to_plot = Callable(value)
	elif value is Array:
		array_to_plot = value

func plot() -> void:
	#----------------------------------------
	# set variables 
	#----------------------------------------
	var _graph_scale = log(zoom) / log(grid_divisions)
	var _graph_scale_float_part = fposmod(_graph_scale, 1.0)
	var _graph_scale_integer_part = ceil(_graph_scale)
	var graph_scale_logalized = pow(grid_divisions, _graph_scale_integer_part)
	var pixel_origin = self.size * normalized_origin 
	var subgrid_size = minimum_subgrid_size * lerp(1, grid_divisions, _graph_scale_float_part) 
	var subgrid_count = ceil(size / subgrid_size) 
	var subgrid_start_position = pixel_origin.posmod(subgrid_size)
	var subgrid_start_count = ceil(-pixel_origin / subgrid_size)

	var subgrid_count_float = size / subgrid_size 
	var value_rect_size =  (value_par_grid * subgrid_count_float) / graph_scale_logalized
	var value_rect_position = -(value_rect_size * normalized_origin)
	var value_rect = Rect2(value_rect_position, value_rect_size)

	#----------------------------------------
	# plot at child nodes
	#----------------------------------------
	$Grid.plot(get_rect(), subgrid_start_position, subgrid_start_count, subgrid_count, subgrid_size, grid_divisions)
	if is_callable:
		$Graph.plot(callable_to_plot, graph_resolution, value_rect, get_rect())
	else:
		$Graph.plot(array_to_plot, graph_resolution,value_rect, get_rect())
	$Scale.test_plot(pixel_origin, grid_divisions, subgrid_start_count, subgrid_start_position, subgrid_count, subgrid_size, value_par_grid, graph_scale_logalized / grid_divisions)


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Setter & Getter
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
func set_zoom(value: float) -> void:
	zoom = value
	zoom_pow = log(zoom) / log(grid_divisions)
	if Engine.is_editor_hint() && _is_child_node_ready():
		plot()

func get_zoom() -> float:
	return zoom

func set_normalized_origin(value: Vector2) -> void:
	normalized_origin = value
	if Engine.is_editor_hint() && _is_child_node_ready():
		plot()

func get_normalized_origin() -> Vector2:
	return normalized_origin

func set_value_par_grid(value: Vector2) -> void:
	value_par_grid = value
	if Engine.is_editor_hint() && _is_child_node_ready():
		plot()

func get_value_par_grid() -> Vector2:
	return value_par_grid

func set_graph_resolution(value: int) -> void:
	graph_resolution = value
	if Engine.is_editor_hint() && _is_child_node_ready():
		plot()

func get_graph_resolution() -> int:
	return graph_resolution

func set_minimum_subgrid_size(value: float) -> void:
	minimum_subgrid_size = value
	if Engine.is_editor_hint() && _is_child_node_ready():
		plot()

func get_minimum_subgrid_size() -> float:
	return minimum_subgrid_size

func set_grid_divisions(value: int) -> void:
	grid_divisions = value
	if Engine.is_editor_hint() && _is_child_node_ready():
		plot()

func get_grid_divisions() -> int:
	return grid_divisions

func set_function_to_plot(value: Callable) -> void:
	callable_to_plot = value

func get_function_to_plot() -> Callable:
	return callable_to_plot

func set_array_to_plot(value: Array) -> void:
	array_to_plot.clear()
	for v in value:
		if v is Vector2:
			array_to_plot.push_back(v)
		elif v is Vector2i:
			array_to_plot.push_back(Vector2(v))

func get_array_to_plot() -> PackedVector2Array:
	return array_to_plot


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Helper functions
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
func _is_child_node_ready() -> bool:
	return has_node("Grid") && has_node("Graph") && has_node("Scale")
