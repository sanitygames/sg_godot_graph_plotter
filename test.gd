@tool
extends Control

@export var ax = 0 : set = set_ax
@export var bx = 0 : set = set_bx



@onready var plotter = $SGGGraphPlotter

var velocity = Vector2.ZERO
var speed = 2.0
var position_log: Array[Vector2] = []


func set_ax(value): 
	ax = value
	if bx != ax * 2:
		bx = ax * 2
		prints(ax, bx)

func set_bx(value):
	bx = value
	if ax != bx / 2:
		ax = bx / 2
		prints(ax, bx)


func _process(delta):
	if Engine.is_editor_hint():
		return
	if Input.is_action_pressed("ui_left"):
		velocity += Vector2.LEFT * speed
		$Label.text = "LEFT"

	if Input.is_action_pressed("ui_right"):
		velocity += Vector2.RIGHT * speed
		$Label.text = "RIGHT"

	if Input.is_action_pressed("ui_up"):
		velocity += Vector2.UP * speed
		$Label.text = "UP"

	if Input.is_action_pressed("ui_down"):
		velocity += Vector2.DOWN * speed
		$Label.text = "DOWN"

	$Icon.position += velocity * delta

	var _p2: Array[Vector2] = [Vector2.ZERO, velocity]
	$Icon/SGGGraphPlotter2.points2plot = _p2
	$Icon/SGGGraphPlotter2.plot()



func _on_timer_timeout():
	position_log.push_back($Icon.position)
	if position_log.size() > 1000:
		var __ = position_log.pop_front()
	plotter.points2plot = position_log
	plotter.plot()
