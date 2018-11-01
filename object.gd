extends PathFollow2D

onready var shape = $shape
var rushing = false
var rushing_to = 0
export(int) var speed = 200
var rush_speed = speed * 2

signal hit_area(id)
signal missed
signal close_miss

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			print("mouse button event")
	
func _physics_process(delta):
	if Input.is_action_just_pressed("hit_area"):
		var space_state = get_world_2d().direct_space_state
		var all_in = true
		var area = null
		for vertex in shape.polygon:
			var global_vertex = shape.to_global(vertex)
			var shapes = space_state.intersect_point(global_vertex, 1)
			if shapes.empty():
				all_in = false
			elif area and area != shapes[0].collider:
				all_in = false
			else:
				area = shapes[0].collider
		if all_in:
			#area.remove_from_group("map_02_areas")
			emit_signal("hit_area", area.get_instance_id())
			print("Inside shape!")
		elif not all_in and area:
			emit_signal("close_miss")
			print("Just missed")
		elif not all_in and not area:
			emit_signal("missed")
			print("completely missed")
	pass

func _process(delta):
	if rushing:
		rush_speed += (speed - rush_speed) * .5 * delta
		set_offset(get_offset() + rush_speed * delta)
		if get_offset() >= rushing_to:
			rushing = false
	else:
		set_offset(get_offset() + speed * delta)
		if Input.is_action_pressed("ui_select"):
			rushing = true
			rush_speed = speed * 2
			rushing_to = get_offset() + speed * 1.5
