tool
extends Node2D

# class member variables go here, for example:
# var a = 2
export(int) var radius = 300 setget set_radius
export(Color) var OutLine = Color(0,0,0) setget set_color
export(float) var Width = 2.0 setget set_width
var color = Color(1.0, 0.0, 0.0)
export(PoolVector2Array) var vertices

func _ready():
	update()
	
func _process(delta):
	if Engine.editor_hint:
		return

func _draw():
	print(vertices)
	var points = vertices
	points.append(points[0])
	draw_polyline(points, OutLine, Width, true)

func set_color(color):
    OutLine = color
    update()

func set_width(new_width):
    Width = new_width
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
	update()
	
func is_type(type): 
	return type == "Polygon2D" or .is_type(type)
func    get_type(): 
	return "poly"
