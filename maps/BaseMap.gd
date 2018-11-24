tool
extends Node2D

export(int) var radius = 300 setget set_radius
export(Color) var OutLine = Color(0,0,0) setget set_color
export(float) var Width = 2.0 setget set_width
var color = Color(1.0, 0.0, 0.0)
export(PoolVector2Array) var vertices

export(int) var obtainable_score
export(String) var AREA_GROUP = "map_01_areas"
var area_map
var completed = false
export(NodePath) var score_label
export(NodePath) var score_bar
export(NodePath) var object
var active = false setget active_set

signal completed(score)
signal hit_area(pos)
signal loss
signal close_miss

func _ready():
	update()
	
func _process(delta):
	if Engine.editor_hint:
		return
	update_look_ats()
	obtainable_score -= 10 * delta
	obtainable_score = max(0.0, obtainable_score)
	get_node(score_bar).value = obtainable_score
	if obtainable_score == 0.0:
		emit_signal("loss")
	update_score()
		
func set_color(color):
	OutLine = color
	for n in get_children():
		if n is Line2D:
			n.set_default_color(color)
	update()

func set_width(new_width):
	Width = new_width
	for n in get_children():
		if n is Line2D:
			n.set_width(new_width)
	update()
	
func set_radius(new_radius):
	var old_radius = radius
	radius = new_radius
	if not Engine.editor_hint:
		return
	var updated_vertices = PoolVector2Array()
	for point in vertices:
		point = point / old_radius
		point = point * new_radius
		updated_vertices.append(point)
	#radius = new_radius
	vertices = updated_vertices
	if vertices:
		create_or_update_path()
	update()
	
func gen_points():
	randomize()
	vertices = PoolVector2Array()
	var angle = 0.0
	var end = 2 * PI
	while (angle < end):
		var x = cos(angle) * radius
		var y = sin(angle) * radius
		angle += deg2rad(randi()%170+10)
		vertices.append(Vector2(x,y))
	update()
	
func create_or_update_path():
	var child_path = null
	for n in get_children():
		if n is Path2D:
			child_path = n
			break
	if child_path:
		var curve = child_path.curve
		curve.clear_points()
		for point in vertices:
			curve.add_point(point)
		curve.add_point(vertices[0])
	else:
		var path = Path2D.new()
		var curve = path.curve
		for point in vertices:
			curve.add_point(point)
		curve.add_point(vertices[0])
		add_child(path)
		path.owner = self
		child_path = path
	var child_line2d = null
	for n in get_children():
		if n is Line2D:
			child_line2d = n
			break
	if child_line2d:
		# clear existing points
		while child_line2d.get_point_count() > 0:
			child_line2d.remove_point(child_line2d.get_point_count() - 1)
		# add updated points to Line2D
		for point in vertices:
			child_line2d.add_point(point)
		child_line2d.add_point(vertices[0])
	else:
		var line2d = Line2D.new()
		for point in vertices:
			line2d.add_point(point)
		line2d.add_point(vertices[0])
		add_child(line2d)
		line2d.owner = self
	update()
	
func is_type(type): 
	return type == "Polygon2D" or .is_type(type)
func    get_type(): 
	return "poly"

func active_set(value):
	active = value
	set_process(value)
	$Path2D/object.set_process(value)
	$Path2D/object.set_physics_process(value)
	if value:
		get_node(score_label).show()
		get_node(score_bar).show()
	if not value:
		get_node(score_label).hide()
		get_node(score_bar).hide()

func update_look_ats():
	var object_pos = get_node(object).global_position
	for member in get_tree().get_nodes_in_group(AREA_GROUP):
		member.get_node(NodePath("Polygon2D/Eyes")).update_look_at(object_pos)
	pass

func show_all_eyes():
	for area in get_tree().get_nodes_in_group(AREA_GROUP):
		area.get_node(NodePath("Polygon2D/Eyes")).show()

func update_score():
	get_node(score_label).text = str(int(obtainable_score))
	
func _on_object_missed():
	emit_signal("loss")

func _on_object_close_miss():
	emit_signal("close_miss")

func _on_object_hit_area(id):
	if completed:
		return
	var area = get_node(NodePath(area_map[id]))
	if not area.is_in_group(AREA_GROUP):
		return
	emit_signal("hit_area", area.get_global_position())
	area.remove_from_group(AREA_GROUP)
	var remaining_areas = get_tree().get_nodes_in_group(AREA_GROUP)

	area.get_node(NodePath("CollisionPolygon2D")).disabled = true
	area.get_node(NodePath("Polygon2D/Eyes")).hide()
	if remaining_areas.empty():
		completed = true
		emit_signal("completed", int(obtainable_score))
