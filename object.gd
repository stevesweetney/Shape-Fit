extends PathFollow2D

onready var square = $Area2D/Polygon2D
var rushing = false
var rushing_to = 0
export(int) var speed = 200

signal scored(score)

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass
	
func _physics_process(delta):
	if Input.is_action_just_pressed("left_click"):
		var space_state = get_world_2d().direct_space_state
		var all_in = true
		for vertex in square.polygon:
			var global_vertex = square.to_global(vertex)
			var shapes = space_state.intersect_point(global_vertex, 1)
			print(shapes)
			if shapes.empty():
				all_in = false
		if all_in:
			emit_signal("scored", 2)
			print("Inside square!")
	pass

func _process(delta):
	if rushing:
		set_offset(get_offset() + speed * 2 * delta)
		if get_offset() > rushing_to:
			rushing = false
	else:
		set_offset(get_offset() + speed * delta)
		if Input.is_action_just_pressed("ui_accept"):
			rushing = true
			rushing_to = get_offset() + speed
