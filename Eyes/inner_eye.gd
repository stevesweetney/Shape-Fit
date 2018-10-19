extends Sprite

export(Vector2) var look_at = Vector2(0,0)

func _process(delta):
	var distance = look_at - global_position
	#print(distance.normalized())
	get_material().set_shader_param("distance", distance)