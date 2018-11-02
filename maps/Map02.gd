tool
extends "BaseMap.gd"

#var area_map
#var active = false setget active_set

func _ready():
	completed = false
	AREA_GROUP = "map_02_areas"
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
	get_node(score_bar).max_value = 800
	self.active = false
	show_all_eyes()
