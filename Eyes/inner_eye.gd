extends Sprite

var look_at = Vector2(0,0)

func _process(delta):
	var distance = look_at - global_position
	get_material().set_shader_param("distance", distance)
