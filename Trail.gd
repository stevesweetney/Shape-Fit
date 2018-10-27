extends Node

export var trail_length = 20
var point
onready var line = $Line2D
export(NodePath) var targetPath
var target

func _ready():
	target = get_node(targetPath)

func _process(delta):
	point = target.global_position
	line.add_point(point)
	while line.get_point_count() > trail_length:
		line.remove_point(0)
