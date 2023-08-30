@tool
extends EditorPlugin


func _enter_tree():
	add_custom_type(
		"SGGGraphPlotter", 
		"Panel", 
		preload("sgg_graph_plotter.gd"), 
		preload("res://icon.svg")
	)


func _exit_tree():
	remove_custom_type("SGGGraphPlotter")
