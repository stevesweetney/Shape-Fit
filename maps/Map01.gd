tool
extends "BaseMap.gd"

#var area_map
#var active = false setget active_set

func _ready():
	completed = false
	AREA_GROUP = "map_01_areas"
	var collision_area1 = $Path2D/collision01/Area2D
	var collision_area2 = $Path2D/collision02/Area2D
	
	collision_area1.add_to_group(AREA_GROUP)
	collision_area2.add_to_group(AREA_GROUP)
	
	area_map = {
		collision_area1.get_instance_id(): "Path2D/collision01/Area2D",
		collision_area2.get_instance_id(): "Path2D/collision02/Area2D"
	}
	obtainable_score = 400
	if Engine.editor_hint:
		return
	get_node(score_bar).max_value = 400
	self.active_set(false)
	show_all_eyes()	
	
