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
# └────────┴───────┴───────┴───────┴─┴─┘	  V0.1
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

var element2plot = func(x): return sin(x)
var zoom_pow = 1.0

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Actions
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
func _enter_tree():
	print("sgggp enter tree")
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

	plot()

func _on_item_rect_changed():
	if Engine.is_editor_hint() && _is_child_node_ready():
		plot()

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Methods
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
func plot():
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	# set variables 
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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
	var func2plot = func(x): return cos(x)

	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	# plot at child nodes
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	$Grid.test_plot(subgrid_start_position, subgrid_start_count, subgrid_count, subgrid_size, grid_divisions)
	$Graph.test_plot(func2plot, graph_resolution, value_rect, get_rect())
	$Scale.test_plot(pixel_origin, grid_divisions, subgrid_start_count, subgrid_start_position, subgrid_count, subgrid_size, value_par_grid, graph_scale_logalized)


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


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Helper functions
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
func _is_child_node_ready() -> bool:
	return has_node("Grid") && has_node("Graph") && has_node("Scale")
