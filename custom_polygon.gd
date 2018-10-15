tool
extends Node2D

# class member variables go here, for example:
# var a = 2
export(int) var radius = 300
export(Color) var OutLine = Color(0,0,0) setget set_color
export(float) var Width = 2.0 setget set_width
var color = Color(1.0, 0.0, 0.0)
var vertices

func _ready():
	randomize()
	vertices = PoolVector2Array()
	var angle = 0.0
	var end = 2 * PI
	while (angle < end):
		var x = cos(angle) * radius
		var y = sin(angle) * radius
		angle += deg2rad(randi()%170+10)
		vertices.append(Vector2(x,y))
	var poly = Polygon2D.new()
	poly.set_polygon(vertices)
	add_child(poly)
	update()

func _draw():
	var points = vertices
	points.append(points[0])
	draw_polyline(points, OutLine, Width, true)

func set_color(color):
    OutLine = color
    update()

func set_width(new_width):
    Width = new_width
    update()
