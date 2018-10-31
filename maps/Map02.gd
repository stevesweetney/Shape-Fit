tool
extends "BaseMap.gd"

var obtainable_score = 800.0
var AREA_GROUP = "map_02_areas"
var area_map
var completed = false
onready var score_label = $Score
onready var score_bar = $ScoreBar
onready var object = $Path2D/object/shape
var active = false setget active_set

signal completed(score)
signal hit_area
signal loss

func _ready():
	var collision_area1 = $Path2D/collision01/Area2D
	var collision_area2 = $Path2D/collision02/Area2D
	var collision_area3 = $Path2D/collision03/Area2D
	var collision_area4 = $Path2D/collision04/Area2D
	
	collision_area1.add_to_group(AREA_GROUP)
	collision_area2.add_to_group(AREA_GROUP)
	collision_area3.add_to_group(AREA_GROUP)
	collision_area4.add_to_group(AREA_GROUP)
	
	area_map = {
		collision_area1.get_instance_id(): "Path2D/collision01/Area2D",
		collision_area2.get_instance_id(): "Path2D/collision02/Area2D",
		collision_area3.get_instance_id(): "Path2D/collision03/Area2D",
		collision_area4.get_instance_id(): "Path2D/collision04/Area2D"
	}
	obtainable_score = 800
	score_bar.max_value = 800
	self.active = false
	show_all_eyes()
	
func active_set(value):
	active = value
	set_process(value)
	$Path2D/object.set_process(value)
	$Path2D/object.set_physics_process(value)
	if value:
		$Score.show()
		score_bar.show()
	if not value:
		$Score.hide()
		score_bar.hide()

func show_all_eyes():
	for area in get_tree().get_nodes_in_group(AREA_GROUP):
		area.get_node(NodePath("Polygon2D/Eyes")).show()
		
func _process(delta):
	if Engine.editor_hint or completed:
		return
	update_look_ats()
	obtainable_score -= 10 * delta
	obtainable_score = max(0.0, obtainable_score)
	score_bar.value = obtainable_score
	if obtainable_score == 0.0:
		emit_signal("loss")
	update_score()
	
func update_look_ats():
	var object_pos = object.global_position
#	$Path2D/collision01/Area2D/Polygon2D/Eyes.update_look_at(object_pos)
#	$Path2D/collision02/Area2D/Polygon2D/Eyes.update_look_at(object_pos)
	for member in get_tree().get_nodes_in_group(AREA_GROUP):
		member.get_node(NodePath("Polygon2D/Eyes")).update_look_at(object_pos)
	pass
	
func _on_object_hit_area(id):
	if completed:
		return
	emit_signal("hit_area")
	var area = get_node(NodePath(area_map[id]))
	area.remove_from_group("map_02_areas")
	var remaining_areas = get_tree().get_nodes_in_group(AREA_GROUP)
	print(remaining_areas.size())

	area.get_node(NodePath("CollisionPolygon2D")).disabled = true
	area.get_node(NodePath("Polygon2D/Eyes")).hide()
	if remaining_areas.empty():
		completed = true
		print("Map completed.")
		emit_signal("completed", int(obtainable_score))
		
func update_score():
	score_label.text = str(int(obtainable_score))
	
	


func _on_object_missed():
	emit_signal("loss")


func _on_object_close_miss():
	emit_signal("close_miss")
