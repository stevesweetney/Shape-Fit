tool
extends "BaseMap.gd"

var obtainable_score = 400.0
var AREA_GROUP = "map_01_areas"
var area_map
var completed = false
onready var score_label = $Score
onready var object = $Path2D/object/square

signal completed(score)

func _ready():
	var collision_area1 = $Path2D/collision01/Area2D
	var collision_area2 = $Path2D/collision02/Area2D
	
	collision_area1.add_to_group(AREA_GROUP)
	collision_area2.add_to_group(AREA_GROUP)
	
	area_map = {
		collision_area1.get_instance_id(): "Path2D/collision01/Area2D",
		collision_area2.get_instance_id(): "Path2D/collision02/Area2D"
	}
	
func _process(delta):
	if Engine.editor_hint or completed:
		return
	update_look_ats()
	obtainable_score -= 10 * delta
	obtainable_score = max(0.0, obtainable_score)
	update_score()
	
func update_look_ats():
	var object_pos = object.global_position
	$Path2D/collision01/Area2D/Polygon2D/Eyes.update_look_at(object_pos)
	$Path2D/collision02/Area2D/Polygon2D/Eyes.update_look_at(object_pos)
	pass
	
func _on_object_hit_area(id):
	if completed:
		return
	var remaining_areas = get_tree().get_nodes_in_group(AREA_GROUP)
	print(remaining_areas.size())
	var area = get_node(NodePath(area_map[id]))
	area.get_node(NodePath("CollisionPolygon2D")).disabled = true
	area.get_node(NodePath("Polygon2D/Eyes")).hide()
	if remaining_areas.empty():
		completed = true
		print("Map completed.")
		emit_signal("completed", int(obtainable_score))
		
func update_score():
	score_label.text = str(int(obtainable_score))
	
	
